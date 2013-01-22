package lv.semti.annotator;
/*******************************************************************************
 * Copyright 2008, 2009 Institute of Mathematics and Computer Science, University of Latvia; 
 * Author: Ilmārs Poikāns
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 * 
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************/

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.StringTokenizer;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import lv.semti.morphology.lexicon.Lexicon;

public class Updater implements Runnable {

	private final static String UPDATE_SITE = "http://dev.ailab.lv/updates/semti/lexicon";
	private final static String EOL = "\r\n";
	
	private static Updater updater;
	
	private Lexicon lexicon;
	private Status status;
	private volatile Thread thread;
	
	
	public static synchronized Updater update(Lexicon lexicon) {

		if (updater == null) {
			updater = new Updater(lexicon);
			updater.start();
		}
		
		return updater;
	}

	
	public static void main(String args[]) throws Exception {

		Updater updater = update(new Lexicon());
		final Status status = updater.getStatus();
		
		StatusListener listener = new StatusListener() {
			
			public void progressChanged(int p) {
				System.out.println(status.getStatusMessage() + ": " + status.getProgress());
			}
			
			public void statusChanged(String s) {
				System.out.println(status.getStatusMessage() + ": " + status.getProgress());
			}
			
			public void updateCompleted(String msg) {
				System.out.println("Update completed - " + status.getCompleteMessage());
			}
			
			public void updateFailed(String msg) {
				System.out.println("Update failed - " + status.getErrorMessage());
			}
		};
		
		status.setListener(listener);
	}
	
	
	public Updater(Lexicon lexicon) {
		this.lexicon = lexicon;
		this.status = new Status();
	}
	
	public Status getStatus() {
		return status;
	}

	public synchronized void start() {
        thread = new Thread(this);
        thread.start();
    }
	
    public void run() {

    	Thread thisThread = Thread.currentThread();
    	
    	try {
    		status.setStatusMessage("Tiek noskaidrota pēdējā leksikona versija...");
	    	String latest = getText(new URL(UPDATE_SITE + "/current"));
	    	int latestRevision = Integer.parseInt(new StringTokenizer(latest).nextToken());
	    	
	    	String messageText = getText(new URL(UPDATE_SITE + "/message.txt"));
	    	
	    	File localLatestLexiconFile = new File("Lexicon-r" + latestRevision + ".xml");
	    	
	    	if (lexicon.getRevisionNumber() == latestRevision || localLatestLexiconFile.exists()) {
	    		status.setUpdateCompleted("Jums jau ir pēdējā leksikona versija." + EOL + messageText);
	    		updater = null;
	    		return;
	    	}
	    	
	    	status.setProgress(10);
	    	if (thisThread != thread) {
	    		updater = null;	    		
	    		return;
	    	}

	    	status.setStatusMessage("Tiek apstrādats lokālais leksikons...");
	    	File userLexiconZipFile = processLocalLexicon(new File(lexicon.getFilename()), 11, 30);

	    	if (thisThread != thread) {
	    		updater = null;	    		
	    		return;
	    	}

	    	status.setStatusMessage("Tiek augšupielādētas leksikona izmaiņas...");
	    	uploadLocalLexicon(userLexiconZipFile, 31, 50); // returns OK or ERROR
	    	userLexiconZipFile.delete();
	    	
	    	if (thisThread != thread) {
	    		updater = null;	    		
	    		return;
	    	}

	    	status.setStatusMessage("Tiek lejupielādēts pēdējais leksikons...");

	    	URL latestLexiconZipUrl = new URL(UPDATE_SITE + "/" + latestRevision + "/Lexicon.zip");
	    	File localLatestLexiconZipFile = new File(localLatestLexiconFile.getAbsoluteFile() + ".zip");
	    	downloadLatestLexicon(latestLexiconZipUrl, localLatestLexiconZipFile, 51, 70);

	    	if (thisThread != thread) {
	    		updater = null;	    		
	    		return;
	    	}

	    	status.setStatusMessage("Tiek apstrādāts lejupielādētais leksikons...");
	    	processDownloadedLexicon(localLatestLexiconZipFile, localLatestLexiconFile, 71, 90);
	    	localLatestLexiconZipFile.delete();
	    	
	    	status.setUpdateCompleted("Leksikona lejupielāde ir pabeigta." + EOL +
	    			                  "Lūdzu, sinhronizējiet leksikonus manuāli." +  EOL +
	    			                  "Lejupielādētais leksikons atrodas:" + EOL +
	    			                  localLatestLexiconFile.getAbsolutePath() + EOL +
	    			                  messageText);

    	} catch (Exception e) {
    		status.setUpdateFailed("Kļūda atjaunojot leksikonu - " + e.getMessage());
    		e.printStackTrace();
    	}
    	
    	thread = null;
    	updater = null;
    }
    
    private String getText(InputStream in) throws IOException {

    	BufferedReader bin = new BufferedReader(new InputStreamReader(in, "UTF-8"));

    	String line = null;
    	StringBuffer text = new StringBuffer();
    	
    	while ((line = bin.readLine()) != null)  	{
    		text.append(line).append(EOL);
    	}
    	
    	bin.close();

    	return text.toString();
    }
    
    
    private String getText(URL url) throws IOException {
    	return getText(url.openStream());
    }
    
    private void transferData(InputStream in, OutputStream out, long size, int progressStart, int progressEnd) throws IOException {
		byte[] buf = new byte[1024];
		int read = 0;
		int totalRead = 0;
		int lastProgress = 0;
		int deltaProgress = progressEnd - progressStart;
		while ((read = in.read(buf)) != -1) {
			out.write(buf, 0, read);
			totalRead += read;
			int progress = Math.min(((int)((1.0 * totalRead / size) * deltaProgress)) + progressStart, progressEnd);
			if (lastProgress != progress) {
				status.setProgress(progress);
				lastProgress = progress;
			}
		}
    }
    
    private File processLocalLexicon(File lexicon, int progressStart, int progressEnd) throws IOException {
    	File lexiconzip = new File(lexicon.getAbsoluteFile() + ".zip");
		InputStream in = new BufferedInputStream(new FileInputStream(lexicon));
		ZipOutputStream out = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(lexiconzip)));
		out.putNextEntry(new ZipEntry(lexicon.getName()));
		transferData(in, out, lexicon.length(), progressStart, progressEnd);
		in.close();
		out.closeEntry();
		out.close();
		return lexiconzip;
	}

    private String uploadLocalLexicon(File lexiconzip, int progressStart, int progressEnd) throws IOException {

    	final String EOL = "\r\n";
    	final String TWO_HYPHENS = "--";
    	final String BOUNDARY =  "---------------------------41184676334";

    	URL url = new URL(UPDATE_SITE + "/upload/"); 
    	
    	HttpURLConnection con = (HttpURLConnection)url.openConnection();
    	con.setDoInput(true);
    	con.setDoOutput(true);
    	con.setUseCaches(false);
    	con.setRequestMethod("POST");
    	con.setRequestProperty("Connection", "Keep-Alive");
    	con.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + BOUNDARY);
  
    	DataOutputStream dout = new DataOutputStream(con.getOutputStream());
    	dout.writeBytes(TWO_HYPHENS + BOUNDARY + EOL);
    	dout.writeBytes("Content-Disposition: form-data; name=\"file\"; filename=\"" + lexiconzip.getName() +"\"" + EOL);
    	dout.writeBytes("Content-Type: application/zip" + EOL);
    	dout.writeBytes(EOL);

		InputStream zipin = new BufferedInputStream(new FileInputStream(lexiconzip));
		transferData(zipin, dout, lexiconzip.length(), progressStart, progressEnd);
		zipin.close();
    	
    	dout.writeBytes(EOL);
    	dout.writeBytes(TWO_HYPHENS + BOUNDARY + TWO_HYPHENS + EOL);
    	dout.close();

    	return getText(con.getInputStream());
    }
    
    private void downloadLatestLexicon(URL url, File savefile, int progressStart, int progressEnd) throws IOException {
    	
		OutputStream out = new BufferedOutputStream(new FileOutputStream(savefile));

    	URLConnection con = url.openConnection();
    	con.setConnectTimeout(5000);
    	con.setReadTimeout(5000);
    	con.connect();
    	
		InputStream in = new BufferedInputStream(con.getInputStream());
		transferData(in, out, con.getContentLength(), progressStart, progressEnd);
		in.close();
		out.close();
    }

    private void processDownloadedLexicon(File lexiconzip, File lexicon, int progressStart, int progressEnd) throws IOException {
		ZipInputStream in = new ZipInputStream(new BufferedInputStream(new FileInputStream(lexiconzip)));
		OutputStream out = new BufferedOutputStream(new FileOutputStream(lexicon));
		ZipEntry zipentry = in.getNextEntry();
		if (!zipentry.getName().equalsIgnoreCase("Lexicon.xml"))
			throw new IOException("There isn't Lexicon.xml in file '" + lexiconzip.getAbsolutePath() + "'");
		transferData(in, out, zipentry.getSize(), progressStart, progressEnd);
		in.close();
		out.close();
	}
    
	public synchronized void stop() {
    	Thread moribund = thread;
        thread = null;
        moribund.interrupt();
    }
		
	
	public static class Status {
		
		private String statusMessage;
		private int progress;
		private boolean completed;
		private String completeMessage;
		private boolean error;
		private String errorMessage; 
		
		private StatusListener listener;

		public synchronized String getStatusMessage() {
			return statusMessage;
		}

		public synchronized void setStatusMessage(String statusMessage) {
			this.statusMessage = statusMessage;
			if (listener != null)
				listener.statusChanged(statusMessage);
		}

		public synchronized int getProgress() {
			return progress;
		}

		public synchronized void setProgress(int progress) {
			this.progress = progress;
			if (listener != null)
				listener.progressChanged(progress);			
		}

		public synchronized boolean isCompleted() {
			return completed;
		}

		public synchronized String getCompleteMessage() {
			return completeMessage;
		}

		public synchronized void setUpdateCompleted(String completeMessage) {
			this.completed = true;
			this.error = false;
			this.completeMessage = completeMessage;
			this.errorMessage = null;
			if (listener != null)
				listener.updateCompleted(completeMessage);
		}

		public synchronized boolean isError() {
			return error;
		}

		public synchronized String getErrorMessage() {
			return errorMessage;
		}

		public synchronized void setUpdateFailed(String errorMessage) {
			this.completed = true;
			this.error = true;
			this.completeMessage = null;
			this.errorMessage = errorMessage;
			if (listener != null)
				listener.updateFailed(errorMessage);
		}

		public synchronized StatusListener getListener() {
			return listener;
		}

		public synchronized void setListener(StatusListener listener) {
			this.listener = listener;
		}
	}
	
	public static interface StatusListener {
		
		public void updateCompleted(String message);
		
		public void updateFailed(String message);
		
		// progress values - 0..100
		public void progressChanged(int progress);

		// for displaying status text like connecting, downloading
		public void statusChanged(String status);
	}

}
