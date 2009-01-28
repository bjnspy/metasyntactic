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

import org.metasyntactic.threading.PriorityMutex;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import org.w3c.dom.Element;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.ByteBuffer;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.util.zip.GZIPInputStream;

/**
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class NetworkUtilities {
  private static final PriorityMutex mutex = new PriorityMutex();

  private NetworkUtilities() {
  }

  public static String downloadString(final String url, final boolean important) {
    try {
      return downloadString(new URL(url), important);
    } catch (final MalformedURLException e) {
      throw new RuntimeException(e);
    }
  }

  private final static String[] charsets = {"UTF-8", "ISO-8859-1",};

  public static String downloadString(final URL url, final boolean important) {
    final byte[] bytes = download(url, important);
    if (bytes == null) {
      return null;
    }

    for (final String charset : charsets) {
      final String result = decode(bytes, charset);
      if (result != null) {
        return result;
      }
    }

    return null;
  }

  private static String decode(final byte[] bytes, final String charset) {
    if (bytes == null) {
      return null;
    }

    try {
      final Charset utfCharset = Charset.forName(charset);
      final CharsetDecoder decoder = utfCharset.newDecoder();
      return decoder.decode(ByteBuffer.wrap(bytes)).toString();
    } catch (final CharacterCodingException ignored) {
      return null;
    }
  }

  public static Element downloadXml(final String url, final boolean important) {
    try {
      return downloadXml(new URL(url), important);
    } catch (final MalformedURLException e) {
      throw new RuntimeException(e);
    }
  }

  private static Element downloadXml(final URL url, final boolean important) {
    final byte[] data = download(url, important);
    if (data == null || data.length == 0) {
      return null;
    }
    return XmlUtilities.parseInputStream(new ByteArrayInputStream(data));
  }

  public static byte[] download(final String url, final boolean important) {
    if (isNullOrEmpty(url)) {
      return null;
    }

    try {
      return download(new URL(url), important);
    } catch (final MalformedURLException e) {
      ExceptionUtilities.log(NetworkUtilities.class, "download", e);
      return null;
    }
  }

  public static byte[] download(final URL url, final boolean important) {
    try {
      mutex.lock(important);
      return downloadWorker(url);
    } finally {
      mutex.unlock(important);
    }
  }

  private static byte[] downloadWorker(final URL url) {
    try {
      final ByteArrayOutputStream out = new ByteArrayOutputStream();
      final BufferedOutputStream bufferedOut = new BufferedOutputStream(out, 1 << 13);

      final URLConnection connection = url.openConnection();
      connection.setRequestProperty("Accept-Encoding", "gzip");
      connection.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)");
      connection.connect();

      final InputStream connectionIn = connection.getInputStream();
      final BufferedInputStream bufferedIn = new BufferedInputStream(connectionIn, 1 << 13);
      final InputStream in;

      final String contentEncoding = StringUtilities.nonNullString(((HttpURLConnection)connection).getContentEncoding());
      if (contentEncoding.toLowerCase().contains("gzip")) {
        in = new GZIPInputStream(bufferedIn, 1 << 13);
      } else {
        in = bufferedIn;
      }

      final byte[] bytes = new byte[1 << 16];
      int length;
      while ((length = in.read(bytes)) > 0) {
        bufferedOut.write(bytes, 0, length);
      }

      bufferedOut.flush();
      out.flush();
      out.close();
      in.close();
      connectionIn.close();

      return out.toByteArray();
    } catch (final IOException e) {
      ExceptionUtilities.log(NetworkUtilities.class, "downloadWorker", e);
      return null;
    }
  }
}
