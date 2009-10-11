//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
package org.metasyntactic.utilities;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.lang.Thread.UncaughtExceptionHandler;
import java.nio.charset.IllegalCharsetNameException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;
import org.metasyntactic.NowPlayingApplication;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.util.Log;

public class ExceptionUtilities {
  public static final DefaultExceptionHandler DEFAULT_EXCEPTION_HANDLER = new DefaultExceptionHandler();
  
  private ExceptionUtilities() {
  }

  public static void log(final Class<?> clazz, final String method,
      final Throwable e) {
    Log.e(clazz.getName(), method, e);
  }

  private static String Version;
  private static String Package;
  private static String FilesPath;

  public static void registerExceptionHandler(Context context) {
    PackageManager pm = context.getPackageManager();
    try {
      PackageInfo pi = pm.getPackageInfo(context.getPackageName(), 0);
      Version = pi.versionName;
      Package = pi.packageName;
      FilesPath = context.getFilesDir().getAbsolutePath();
    } catch (NameNotFoundException e) {
      e.printStackTrace();
    }

    new Thread() {
      @Override
      public void run() {
        submitStackTraces();
        Thread.setDefaultUncaughtExceptionHandler(DEFAULT_EXCEPTION_HANDLER);
      }
    }.start();
  }
  private static String[] searchForStackTraces() {
    File dir = new File(FilesPath + "/");
    dir.mkdirs();

    FilenameFilter filter = new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return name.endsWith(".stacktrace");
      }
    };
    return dir.list(filter);
  }

  /**
   * Look into the files folder to see if there are any "*.stacktrace" files. If
   * any are present, submit them to the trace server.
   */
  public static void submitStackTraces() {
    try {
      String[] list = searchForStackTraces();
      if (list != null && list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          File file = new File(FilesPath, list[i]);
          String version = list[i].split("-")[0];
          StringBuilder contents = new StringBuilder();
          BufferedReader input = new BufferedReader(new FileReader(file));
          String line = null;
          while ((line = input.readLine()) != null) {
            contents.append(line);
            contents.append(System.getProperty("line.separator"));
          }
          input.close();
          String stacktrace;
          stacktrace = contents.toString();
          file.delete();
          
          DefaultHttpClient httpClient = new DefaultHttpClient();
          HttpPost httpPost = new HttpPost("http://" + NowPlayingApplication.host + ".appspot.com/ReportCrash");
          List<NameValuePair> nvps = new ArrayList<NameValuePair>();
          nvps.add(new BasicNameValuePair("name", Package));
          nvps.add(new BasicNameValuePair("version", version));
          nvps.add(new BasicNameValuePair("trace", stacktrace));
          httpPost.setEntity(new UrlEncodedFormEntity(nvps, HTTP.UTF_8));

          httpClient.execute(httpPost);
        }
      }
    } catch (Exception e) {
    } finally {
      String[] list = searchForStackTraces();
      for (int i = 0; i < list.length; i++) {
        File file = new File(FilesPath, list[i]);
        file.delete();
      }
    }
  }

  public static class DefaultExceptionHandler implements UncaughtExceptionHandler {
    public void uncaughtException(Thread t, Throwable e) {
      if (FilesPath == null) {
        return;
      }
      
      final Writer result = new StringWriter();
      final PrintWriter printWriter = new PrintWriter(result);
      e.printStackTrace(printWriter);
      String filename = Version + "-" + new Date().getTime();
      try {
        BufferedWriter bos = new BufferedWriter(new FileWriter(new File(
            FilesPath, filename + ".stacktrace")));
        bos.write(result.toString());
        bos.flush();
        bos.close();
      } catch (Exception e1) {
      }
    }

    public void uncaughtException(Throwable e) {
      uncaughtException(Thread.currentThread(), e);
    }
  }
}