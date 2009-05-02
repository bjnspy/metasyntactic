import org.w3c.dom.Comment;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class Program {
    private static final Collection<String> classes = new TreeSet<String>();
    private static final List<File> stringsFiles = new ArrayList<File>();

    private Program() {
    }

    public static void main(final String... args)
            throws IOException, InterruptedException, ParserConfigurationException, TransformerException, NoSuchAlgorithmException {
        findStringsFiles(new File(args[0]));
        processDirectory(new File(args[0]));
        //processStringsFiles();
        //generateAndroidFiles();
        //printForwardDeclaration();
    }

    private static void findStringsFiles(final File directory) {
        for (final File child : directory.listFiles()) {
            if (".svn".equals(child.getName())) {
                continue;
            }

            if (child.isDirectory()) {
                findStringsFiles(child);
            }

            if (child.getPath().contains("Resources") && "Localizable.strings".equals(child.getName())) {
                stringsFiles.add(child);
            }
        }
    }

    private static void processFile(final File child) throws IOException, InterruptedException, NoSuchAlgorithmException {
        //checkImports(child);
        //generateForwardDeclarations(child);
        //checkDealloc(child);
        //removeUnusedImports(child);
        insertCopyright(child);
        trimRight(child);
        //organizeStringsFile(child);
        //formatCode(child);
        //normalizeProjectFile(child);
        trim(child);
    }

    private static void generateAndroidFiles() throws IOException, ParserConfigurationException, TransformerException {
        for (final File file : stringsFiles) {
            final Map<String, Pair> entries = getLocalizableEntries(file);

            final String path = file.getPath();
            String language = getLanguage(path);

            if (language.contains("_")) {
                language = language.substring(0, language.indexOf('_')) + "-r" + language.substring(language.indexOf('_') + 1);
            }

            final File directory = new File("/Projects/metasyntactic/trunk/NowPlaying/Android/res", "values-" + language);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            final File outfile = new File(directory, "strings.xml");

            final Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
            final Comment copyright = document.createComment('\n' + getCopyright("    "));
            document.appendChild(copyright);

            final Element resourcesElement = document.createElement("resources");
            document.appendChild(resourcesElement);

            for (final Map.Entry<String, Pair> e : entries.entrySet()) {
                final Element stringElement = document.createElement("string");

                final String key = makeAndroidKey(e.getKey());
                final String value = makeAndroidValue(e.getValue().first);

                stringElement.setAttribute("name", key);
                stringElement.setTextContent(value);

                if ("en".equals(language)) {
                    resourcesElement.appendChild(document.createComment(e.getKey()));
                }
                resourcesElement.appendChild(stringElement);
            }

            final Transformer transformer = TransformerFactory.newInstance().newTransformer();
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");

            transformer.transform(new DOMSource(document), new StreamResult(outfile));
        }
    }

    private static String getLanguage(final String path) {
        final int end = path.indexOf(".lproj");
        final int start = path.lastIndexOf('/', end);
        final String language = path.substring(start + 1, end);
        return language;
    }

    private static String makeAndroidValue(String value) {
        value = value.replaceAll("'", "\\'");
        for (int i = 1; i <= 9; i++) {
            value = value.replace(String.valueOf(i) + '$', "");
        }
        value = value.replace("%@", "%s");
        return value;
    }

    private static String makeAndroidKey(String key) {
        final StringBuilder sb = new StringBuilder();
        key = key.toLowerCase();
        key = key.replace("%@", "string");
        key = key.replace("%d", "number");
        key = key.replace("1", "one");
        key = key.replace(".", "_dot_");
        key = key.replace("\\n", "_");
        key = key.replace(" ", "_");
        key = key.replace("$", "dollar");
        key = key.replace(":", "_colon_");
        key = key.replace("(", "_paren_");
        key = key.replace(")", "_paren_");

        for (int i = 0; i < key.length(); i++) {
            final char c = key.charAt(i);
            if (Character.isJavaIdentifierPart(c)) {
                sb.append(c);
            }
        }

        if (!Character.isJavaIdentifierStart(sb.charAt(0))) {
            sb.insert(0, '_');
        }


        String result = sb.toString();
        result = result.replace("__", "_");
        result = result.replace("__", "_");

        while (result.endsWith("_")) {
            result = result.substring(0, result.length() - 1);
        }

        if (result.length() > 50) {
            result = result.substring(0, result.lastIndexOf('_', 50));
        }

        return result;
    }

    private static void processStringsFiles() throws IOException {
        if (stringsFiles.size() <= 1) {
            return;
        }

        Map<String, Pair> localizableEntries = null;
        for (final File file : stringsFiles) {
            if (file.getPath().contains("en.lproj")) {
                localizableEntries = getLocalizableEntries(file);
                break;
            }
        }

        for (int i = 0; i < stringsFiles.size(); i++) {
            final Collection<String> missingStrings = new TreeSet<String>();
            final File file = stringsFiles.get(i);
            final String path = file.getPath();
            final Set<String> set1 = getLocalizableIdentifiers(file);

            for (int j = 0; j < stringsFiles.size(); j++) {
                if (j == i) {
                    continue;
                }

                final Set<String> set2 = getLocalizableIdentifiers(stringsFiles.get(j));
                final Collection<String> difference = new TreeSet<String>(set2);
                difference.removeAll(set1);
                missingStrings.addAll(difference);
            }

            final File locFile = new File("/Temp/Localization/" + new Locale(getLanguage(path)).getDisplayName(Locale.ENGLISH) + ".txt");
            locFile.delete();
            if (!missingStrings.isEmpty()) {
                System.out.println("Identifiers missing in: " + path);

                for (final String s : missingStrings) {
                    System.out.println("\t\"" + s + "\" = \"\";");
                }

                String text = "Localizers, please read the following instructions before proceeding.\n" +
                        '\n' +
                        "All text starting with // (including this line) should not be translated.  It is\n" +
                        "purely for providing instructions and hints\n" +
                        '\n' +
                        "Text that needs to be translated comes in the form:\n" +
                        '\n' +
                        "    \"1 kilometer\" = \"\";\n" +
                        '\n' +
                        "You will provide the translation on the *right hand side* of the equals (=) sign.\n" +
                        "i.e. if we were translating this to french we would end up with:\n" +
                        '\n' +
                        "    \"1 kilometer\" = \"1 kilomètre\";\n" +
                        '\n' +
                        "Most cases should be fairly simple, however there can be slight complications.\n" +
                        "Sometimes we will not know a value at this moment, but it will instead be \n" +
                        "supplied when the program runs.  i.e.:\n" +
                        '\n' +
                        "    /* i.e.: 2 hours */\n" +
                        "    \"%d hours\" = \"\";\n" +
                        '\n' +
                        "In this case the '%d' will be replaced with a number.  This entity *must* appear\n" +
                        "in your localized text.  Here are some examples of that translated into other\n" +
                        "languages:\n" +
                        '\n' +
                        "French: \"%d hours\" = \"%d heures\";\n" +
                        "Hebrew: \"%d hours\" = \"שעות %d\";\n" +
                        '\n' +
                        "Note that Hebrew switched the order of the order of the words here.\n" +
                        '\n' +
                        "Finally, you will also see strings of the form:\n" +
                        '\n' +
                        "    /* %@ will be replaced with a movie showtime.  i.e.: Order tickets for 3:15pm */\n" +
                        "    \"Order tickets for %@\" = \"\"\n" +
                        '\n' +
                        "As with before, the %@ will be replaced by the program when it is running and\n" +
                        "*must* appear in your localized text.  Here is an example of that translated into\n" +
                        "other languages:\n" +
                        '\n' +
                        "French: \"Order tickets for %@\" = \"Commander un billet pour %@\";\n" +
                        "German: \"Order tickets for %@\" = \"für %@ bestellen\";\n" +
                        "Hebrew: \"Order tickets for %@\" = \"%@ הזמן כרטיסים עבור\";\n" +
                        '\n' +
                        "Again note that the replacement text can occur wherever you think is appropriate\n" +
                        "for your language.  In cases of replacements i have tried to provide helpful text\n" +
                        "to explain how the values will be replaced.\n" +
                        '\n' +
                        "If you have any questions, please feel free to email me at:\n" +
                        "cyrus.najmabadi@gmail.com\n" +
                        '\n' +
                        "Thanks very much!";

                text = commentText("// ", text);

                for (final String s : missingStrings) {
                    text += "\n\n";
                    final Pair pair = localizableEntries.get(s);
                    if (pair != null && !"/* No comment provided by engineer. */".equals(pair.second)) {
                        text += "// " + stripComment(pair.second) + "\n";
                    }
                    text += "\"" + s + "\" = \"\";";
                }

                writeFile(locFile, text);
            }
        }
    }

    private static String stripComment(String second) {
        second = second.trim();
        if (second.startsWith("/*")) {
            second = second.substring(2);
        }
        if (second.endsWith("*/")) {
            second = second.substring(0, second.length() - 2);
        }
        return second.trim();
    }

    private static class Pair {
        private String first;
        private String second;

        private Pair(final String first, final String second) {
            this.first = first;
            this.second = second;
        }

        @Override
        public boolean equals(final Object o) {
            if (this == o) return true;
            if (!(o instanceof Pair)) return false;

            final Pair pair = (Pair) o;

            if (!first.equals(pair.first)) return false;
            if (!second.equals(pair.second)) return false;

            return true;
        }

        @Override
        public int hashCode() {
            int result = first.hashCode();
            result = 31 * result + second.hashCode();
            return result;
        }
    }

    private static Map<String, Pair> getLocalizableEntries(final File file) throws IOException {
        final Map<String, Pair> entries = new TreeMap<String, Pair>();

        final LineNumberReader in = new LineNumberReader(new InputStreamReader(new FileInputStream(file), "utf16"));

        String comment = "";
        String line;
        while ((line = in.readLine()) != null) {
            line = line.trim();
            if (line.startsWith("/*")) {
                comment = line;
            }
            if (line.startsWith("\"")) {
                final int secondQuote = line.indexOf('\"', 1);
                final int thirdQuote = line.indexOf('\"', secondQuote + 1);
                final int fourthQuote = line.indexOf('\"', thirdQuote + 1);
                final String key = line.substring(1, secondQuote);
                final String value = line.substring(thirdQuote + 1, fourthQuote);

                entries.put(key, new Pair(value, comment));
            }
        }

        return Collections.unmodifiableMap(entries);
    }

    private static Set<String> getLocalizableIdentifiers(final File file) throws IOException {
        return getLocalizableEntries(file).keySet();
    }

    private static void printForwardDeclaration() {
        for (final String s : classes) {
            System.out.println("@class " + s + ';');
        }
    }

    private static void processDirectory(final File directory) throws IOException, InterruptedException, NoSuchAlgorithmException {
        for (final File child : directory.listFiles()) {
            if (".svn".equals(child.getName())) {
                continue;
            }

            if ("Expat".equals(child.getName())) {
                continue;
            }

            if (child.getName().contains("pb.m")) {
                continue;
            }

            if (child.isDirectory()) {
                processDirectory(child);
            } else {
                processFile(child);
            }
        }
    }

    private static void trim(final File child) throws IOException {
        if (!child.getName().endsWith(".m") && !child.getName().endsWith(".h")) {
            return;
        }

        final String original = readFile(child);
        if (!original.trim().equals(original)) {
            writeFile(child, original);
        }
    }

    private static void organizeStringsFile(final File child) throws IOException, UnsupportedEncodingException {
        if (!child.getName().endsWith(".strings") || !child.getPath().contains("Resources")) {
            return;
        }

        Map<String, Pair> englishEntries = null;
        for (final File file : stringsFiles) {
            if (file.getPath().contains("en.lproj")) {
                englishEntries = getLocalizableEntries(file);
                break;
            }
        }

        final Map<String, Pair> localizableEntries = getLocalizableEntries(child);

        final StringWriter stringWriter = new StringWriter();
        final PrintWriter printer = new PrintWriter(stringWriter);
        printer.println(getCopyright("// "));

        for (final Map.Entry<String, Pair> entry : localizableEntries.entrySet()) {
            printer.println();
            final String english = entry.getKey();
            final String translated = entry.getValue().first;
            final Pair englishPair = englishEntries.get(english);
            String comment = englishPair == null ? null : englishPair.second;

            if (comment == null) {
                comment = "/* No comment provided by engineer. */";
            }

            printer.println(comment);
            printer.println("\"" + english + "\" = \"" + translated + "\";");
        }

        final Writer out = new OutputStreamWriter(new FileOutputStream(child), "utf16");

        out.write(stringWriter.toString().trim());

        out.flush();
        out.close();
    }

    private static Map<String, String> getLinesAndComments(final File child) throws IOException {
        final Map<String, String> map = new TreeMap<String, String>();

        final LineNumberReader in = new LineNumberReader(new InputStreamReader(new FileInputStream(child), "utf16"));

        String comment = "";
        String line;
        while ((line = in.readLine()) != null) {
            line = line.trim();
            if (line.startsWith("/*")) {
                comment = line;
            }
            if (line.startsWith("\"")) {
                if (!line.endsWith(";")) {
                    System.out.println("Missing semicolon: " + child.getPath() + ':' + line);
                }

                if (map.containsKey(line)) {
                    System.out.println("Duplicate key: " + child.getPath() + ':' + line);
                }

                map.put(line, comment);
            }
        }
        return map;
    }

    private static void normalizeProjectFile(final File child) throws IOException, NoSuchAlgorithmException {
        if (!child.getPath().endsWith(".pbxproj")) {
            return;
        }

        final String fileText = readFile(child);

        final Pattern pattern = Pattern.compile("([0-9A-F]{24}) /\\* (.*?) \\*/");
        final SortedSet<HashAndHint> values = new TreeSet<HashAndHint>();
        final Map<String, String> hashingMap = new LinkedHashMap<String, String>();

        {
            final Matcher matcher = pattern.matcher(fileText);

            while (matcher.find()) {
                final HashAndHint hah = new HashAndHint(matcher.group(1), matcher.group(2));
                values.add(hah);
            }
        }

        {
            BigInteger start = new BigInteger(new byte[]{
                    0x10, 0, 0, 0,
                    0, 0, 0, 0,
                    0, 0, 0, 0
            });
            for (final HashAndHint hah : values) {
                final String hash =  start.toString(16);
                hashingMap.put(hah.hash, hash);
                start = start.add(BigInteger.ONE);
            }
        }
        {
            final Matcher matcher = pattern.matcher(fileText);
            final StringBuffer sb = new StringBuffer(fileText.length());
            while (matcher.find()) {
                final String oldHash = matcher.group(1);
                final String newHash = hashingMap.get(oldHash);
                matcher.appendReplacement(sb, newHash + " /* " + matcher.group(2) + " */");
            }
            matcher.appendTail(sb);

            final String result = sb.toString();
            //System.out.println(result);

            if (!result.trim().equals(fileText.trim())) {
                writeFile(child, result);
            }
        }
    }

    private static class HashAndHint implements Comparable<HashAndHint> {
        private final String hash;
        private final String hint;

        private HashAndHint(final String hash, final String hint) {
            this.hash = hash;
            this.hint = hint;
        }

        @Override
        public boolean equals(final Object o) {
            if (this == o) return true;
            if (!(o instanceof HashAndHint)) return false;

            final HashAndHint that = (HashAndHint) o;

            if (!hash.equals(that.hash)) return false;
            if (!hint.equals(that.hint)) return false;

            return true;
        }

        @Override
        public int hashCode() {
            int result = hash.hashCode();
            result = 31 * result + hint.hashCode();
            return result;
        }

        @Override
        public int compareTo(final HashAndHint hashAndHint) {
            if (hashAndHint == this) {
                return 0;
            }

            final int val = hint.compareTo(hashAndHint.hint);
            if (val != 0) {
                return val;
            }

            return hash.compareTo(hashAndHint.hash);
        }
    }


    private static void formatCode(final File child) throws IOException {
        if (!child.getName().endsWith(".m") && !child.getName().endsWith(".h")) {
            return;
        }

        final LineNumberReader in = new LineNumberReader(new FileReader(child));

        final StringWriter stringWriter = new StringWriter();
        final PrintWriter printer = new PrintWriter(stringWriter);

        String line;
        final int index = 0;
        while ((line = in.readLine()) != null) {
            printer.println(line);

            final int firstColonIndex = line.indexOf(':');
            if (firstColonIndex < 0 || line.trim().startsWith("case ")) {
                continue;
            }
            if (line.contains(";") || line.contains("{") || line.contains("}")) {
                continue;
            }

            while ((line = in.readLine()) != null) {
                final int lineIndexColon = line.indexOf(':');
                if (lineIndexColon < 0 || line.trim().startsWith("case ")) {
                    printer.println(line);
                    break;
                }

                if (lineIndexColon < firstColonIndex) {
                    printer.print(createWhitespate(firstColonIndex - lineIndexColon));
                    printer.println(line);
                } else if (lineIndexColon > firstColonIndex) {
                    final int lengthToTrim = lineIndexColon - firstColonIndex;
                    final String trim = line.substring(0, lengthToTrim);
                    if (trim.trim().length() == 0) {
                        printer.println(line.substring(lengthToTrim));
                    } else {
                        printer.println(line.trim());
                    }
                } else {
                    printer.println(line);
                }

                if (line.contains(";") || line.contains("{") || line.contains("}")) {
                    break;
                }
            }
        }

        printer.flush();
        final String contents = stringWriter.toString().trim();
        if (!contents.equals(readFile(child))) {
            System.out.println("Formatting: " + child);
            writeFile(child, contents);
        }
    }

    private static String createWhitespate(final int count) {
        final StringBuilder builder = new StringBuilder();
        for (int i = 0; i < count; i++) {
            builder.append(' ');
        }
        return builder.toString();
    }

    private static void insertCopyright(final File child) throws IOException {
        if (!child.getName().endsWith(".m") && !child.getName().endsWith(".h")) {
            return;
        }

        if (child.getPath().toLowerCase().contains("oauth")) {
            return;
        }

        if (child.getParentFile().getPath().contains("Jukebox")) {
            return;
        }

        if (child.getParentFile().getPath().contains("Medialytics")) {
            return;
        }

        if (child.getParentFile().getPath().contains("Expat")) {
            return;
        }

        //if (child.getParent().toLowerCase().contains("protocolbufers")) {
        //    return;
        //}

        final String copyright = getCopyright("// ");

        final LineNumberReader in = new LineNumberReader(new FileReader(child));

        final StringWriter stringWriter = new StringWriter();
        final PrintWriter printer = new PrintWriter(stringWriter);

        String line;
        final int index = 0;
        while ((line = in.readLine()) != null) {
            if (!line.startsWith("//") && !"".equals(line.trim())) {
                break;
            }
        }

        printer.println(copyright);
        printer.println();
        printer.println(line);
        while ((line = in.readLine()) != null) {
            printer.println(line);
        }


        final String contents = stringWriter.toString().trim();
        if (!contents.equals(readFile(child))) {
            writeFile(child, contents);
        }
    }

    private static String getCopyright() {
        final String apacheLicense = "Copyright 2008 Cyrus Najmabadi\n" + '\n' + "Licensed under the Apache License, Version 2.0 (the \"License\");\n" + "you may not use this file except in compliance with the License.\n" + "You may obtain a copy of the License at\n" + '\n' + "    http://www.apache.org/licenses/LICENSE-2.0\n" + '\n' + "Unless required by applicable law or agreed to in writing, software\n" + "distributed under the License is distributed on an \"AS IS\" BASIS,\n" + "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n" + "See the License for the specific language governing permissions and\n" + "limitations under the License.";

        final String gplLicense = "Copyright 2008 Cyrus Najmabadi\n" + '\n' + "This program is free software; you can redistribute it and/or modify it\n" + "under the terms of the GNU General Public License as published by the Free\n" + "Software Foundation; either version 2 of the License, or (at your option) any\n" + "later version.\n" + '\n' + "This program is distributed in the hope that it will be useful, but WITHOUT\n" + "ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS\n" + "FOR A PARTICULAR PURPOSE. See the GNU General Public License for more\n" + "details.\n" + '\n' + "You should have received a copy of the GNU General Public License along with\n" + "this program; if not, write to the Free Software Foundation, Inc., 51\n" + "Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.";

        final String bsdLicense = "Copyright 2008 Cyrus Najmabadi\n" + "All rights reserved.\n" + '\n' + "Redistribution and use in source and binary forms, with or without\n" + "modification, are permitted provided that the following conditions are met:\n" + '\n' + "  Redistributions of source code must retain the above copyright notice, this\n" + "  list of conditions and the following disclaimer.\n" + '\n' + "  Redistributions in binary form must reproduce the above copyright notice,\n" + "  this list of conditions and the following disclaimer in the documentation\n" + "  and/or other materials provided with the distribution.\n" + '\n' + "  Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be\n" + "  used to endorse or promote products derived from this software without\n" + "  specific prior written permission.\n" + '\n' + "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\"\n" + "AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE\n" + "IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE\n" + "ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE\n" + "LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR\n" + "CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF\n" + "SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS\n" + "INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN\n" + "CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)\n" + "ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE\n" + "POSSIBILITY OF SUCH DAMAGE.";

        return apacheLicense;
    }

    private static String getCopyright(final String linePrefix) {
        final String text = getCopyright();
        return commentText(linePrefix, text);
    }

    private static String commentText(final String linePrefix, final String text) {
        final StringBuilder result = new StringBuilder();

        for (final String line : text.split("\n")) {
            result.append(linePrefix);
            result.append(line);
            result.append('\n');
        }

        return result.toString().trim();
    }

    private static void trimRight(final File child) throws IOException {
        if (!child.getName().endsWith(".m") && !child.getName().endsWith(".h")) {
            return;
        }

        final String originalFile = readFile(child);

        final LineNumberReader in = new LineNumberReader(new FileReader(child));

        final StringWriter stringWriter = new StringWriter();
        final PrintWriter printer = new PrintWriter(stringWriter);

        String line;
        while ((line = in.readLine()) != null) {
            printer.println(trimRight(line));
        }

        printer.flush();
        final String newFile = stringWriter.toString().trim();

        if (!newFile.equals(originalFile)) {
            System.out.println("Organizing code: " + child.getPath());
            writeFile(child, newFile);
        }
    }

    private static String trimRight(final String line) {
        if ("".equals(line.trim())) {
            return "";
        }

        int lastNonWhite = line.length();
        while (line.charAt(lastNonWhite - 1) == ' ') {
            lastNonWhite--;
        }

        return line.substring(0, lastNonWhite);
    }

    private static void removeUnusedImports(final File child) throws IOException, InterruptedException {
        if (!child.getName().endsWith(".m") && !child.getName().endsWith(".h")) {
            return;
        }

        System.out.println("Removing imports: " + child.getPath());
        while (removeAnyImport(child)) {

        }
    }

    private static boolean removeAnyImport(final File child) throws IOException, InterruptedException {
        for (int i = 1; i < importCount(child); i++) {
            if (removeImport(child, i)) {
                return true;
            }
        }

        return false;
    }

    private static boolean removeImport(final File child, final int i) throws IOException, InterruptedException {
        final String contents = readFile(child);

        removeImportWorker(child, i);

        final boolean canRemove = compile();

        if (canRemove) {
            System.out.println("Can remove import: " + child.getPath());
        } else {
            writeFile(child, contents);
        }

        return canRemove;
    }

    private static void removeImportWorker(final File child, final int i) throws IOException {
        final LineNumberReader in = new LineNumberReader(new FileReader(child));

        final StringWriter stringWriter = new StringWriter();
        final PrintWriter printer = new PrintWriter(stringWriter);

        String line;
        int index = 0;
        while ((line = in.readLine()) != null) {
            if (line.trim().startsWith("#import")) {
                if (index == i) {
                    printer.print("//");
                    System.out.println("Commenting out: " + line);
                }

                index++;
            }

            printer.println(line);
        }

        final String contents = stringWriter.toString();
        writeFile(child, contents);
    }

    private static void writeFile
            (final File child, final String contents) throws IOException {
        final Writer out = new FileWriter(child);

        out.write(contents.trim());

        out.flush();
        out.close();
    }

    private static String readFile(final File child) throws IOException {
        final StringBuilder sb = new StringBuilder();

        final Reader in = new FileReader(child);
        int c;
        while ((c = in.read()) != -1) {
            sb.append((char) c);
        }
        in.close();

        return sb.toString();
    }

    private static String getProject() {
        for (final String file : new File(".").list()) {
            if (file.endsWith(".xcodeproj")) {
                return file;
            }
        }

        throw new RuntimeException();
    }

    private static boolean compile() throws IOException, InterruptedException {
        final Process process = Runtime.getRuntime().exec("/usr/bin/xcodebuild -project " + getProject());

        new StreamGobbler(process.getErrorStream()).start();
        new StreamGobbler(process.getInputStream()).start();

        final int exitCode = process.waitFor();

        return exitCode == 0;
    }

    private static int importCount(final File child) throws IOException {
        final LineNumberReader in = new LineNumberReader(new FileReader(child));
        String line;
        int count = 0;
        while ((line = in.readLine()) != null) {
            final String trimmedLine = line.trim();

            if (trimmedLine.startsWith("#import")) {
                count++;
            }
        }

        return count;
    }

    private static void checkImports(final File child) throws IOException {
        if (!child.getName().endsWith(".m") && !child.getName().endsWith(".h")) {
            return;
        }

        final Collection<String> beforeImports = new ArrayList<String>();
        final Collection<String> afterImports = new ArrayList<String>();

        final Collection<String> imports = new ArrayList<String>();

        boolean first = true;
        final LineNumberReader in = new LineNumberReader(new FileReader(child));
        String line;
        while ((line = in.readLine()) != null) {
            final String trimmedLine = line.trim();

            if (trimmedLine.startsWith("#import")) {
                if (first) {
                    first = false;
                    beforeImports.add(line);
                    continue;
                }

                imports.add(trimmedLine);
            } else {
                if (imports.isEmpty()) {
                    beforeImports.add(line);
                } else {
                    afterImports.add(line);
                }
            }
        }

        in.close();

        final Set<String> sortedImports = new TreeSet<String>(new Comparator<String>() {
            @Override
            public int compare(final String s1, final String s2) {
                if (s1.contains("<") && !s2.contains("<")) {
                    return -1;
                } else if (s2.contains("<") && !s1.contains("<")) {
                    return 1;
                }

                return s1.compareTo(s2);
            }
        });
        sortedImports.addAll(imports);

        if (imports.equals(new ArrayList<String>(sortedImports))) {
            return;
        }

        System.out.println("Unsorted imports: " + child.getPath());
        for (final String imp : sortedImports) {
            System.out.println(imp);
        }

        final PrintWriter out = new PrintWriter(new FileWriter(child));
        for (final String s : beforeImports) {
            out.println(s);
        }

        for (final String s : sortedImports) {
            out.println(s);
        }

        for (final String s : afterImports) {
            out.println(s);
        }

        out.flush();
        out.close();
    }

    private static void generateForwardDeclarations(final File child) throws IOException {
        if (!child.getName().endsWith(".h")) {
            return;
        }

        final LineNumberReader in = new LineNumberReader(new FileReader(child));
        String line;
        while ((line = in.readLine()) != null) {
            line = line.trim();
            if (line.startsWith("@interface ")) {
                final StringBuilder sb = new StringBuilder();

                for (int i = "@interface ".length(); Character.isLetterOrDigit(line.charAt(i)); i++) {
                    sb.append(line.charAt(i));
                }

                classes.add(sb.toString());
            }
        }
    }

    private static void checkDealloc(final File child) throws IOException {
        if (!child.getName().endsWith(".m")) {
            return;
        }

        final List<String> variables = findVariables(child);

        if (variables.isEmpty()) {
            return;
        }

        if (!hasDeallocMethod(child)) {
            System.out.println("Missing dealloc method: " + child.getPath());
            return;
        }

        if (!hasCallToSuper(child)) {
            System.out.println("Missing [super dealloc] call: " + child.getPath());
            return;
        }

        if (!nilsOutVariable(child, variables)) {
            return;
        }

        if (!correctNilOrder(child, variables)) {
            return;
        }
    }

    private static boolean correctNilOrder(final File child, List<String> variables) throws IOException {
        variables = new ArrayList<String>(variables);

        if (variables.isEmpty()) {
            System.out.println("");
        }

        final LineNumberReader in = new LineNumberReader(new FileReader(child));
        String line;
        while ((line = in.readLine()) != null) {
            line = line.trim();
            if ("- (void) dealloc {".equals(line)) {
                break;
            }
        }

        while ((line = in.readLine()) != null) {
            if (line.startsWith("}")) {
                return true;
            }

            line = line.trim();
            if (line.startsWith("self.") && (line.endsWith(" = nil;") || line.endsWith(" = 0;") || line.endsWith(" = NO;"))) {
                if (variables.isEmpty()) {
                    System.out.println("Dealloc has too many variables: " + child.getPath());
                    return true;
                }

                if (!line.startsWith("self." + variables.get(0))) {
                    System.out.println("Incorrect nil ordering: " + child.getPath());
                    return false;
                }

                variables.remove(0);
            }
        }

        return true;
    }

    private static boolean nilsOutVariable(final File child, final Iterable<String> variables) throws IOException {
        for (final String variable : variables) {
            if (!nilsOutVariable(child, variable)) {
                System.out.println("Missing nil-out for '" + variable + "': " + child.getPath());
                return false;
            }
        }

        return true;
    }

    private static boolean nilsOutVariable(final File child, final String variable) throws IOException {
        final LineNumberReader in = new LineNumberReader(new FileReader(child));
        String line;
        while ((line = in.readLine()) != null) {
            line = line.trim();
            if ("- (void) dealloc {".equals(line)) {
                break;
            }
        }

        while ((line = in.readLine()) != null) {
            if (line.startsWith("}")) {
                return false;
            }

            line = line.trim();
            if (line.equals("self." + variable + " = nil;") || line.equals("self." + variable + " = 0;") || line.equals(
                    "self." + variable + " = NO;")) {
                return true;
            }
        }

        return false;
    }

    private static boolean hasCallToSuper(final File child) throws IOException {
        final LineNumberReader in = new LineNumberReader(new FileReader(child));
        String line;
        while ((line = in.readLine()) != null) {
            line = line.trim();
            if ("- (void) dealloc {".equals(line)) {
                break;
            }
        }

        while ((line = in.readLine()) != null) {
            if (line.startsWith("}")) {
                return false;
            }

            line = line.trim();
            if ("[super dealloc];".equals(line)) {
                return true;
            }
        }

        return false;
    }

    private static boolean hasDeallocMethod(final File child) throws IOException {
        final LineNumberReader in = new LineNumberReader(new FileReader(child));
        String line;
        while ((line = in.readLine()) != null) {
            line = line.trim();
            if ("- (void) dealloc {".equals(line)) {
                return true;
            }
        }

        return false;
    }

    private static List<String> findVariables(final File child) throws IOException {
        final List<String> variables = new ArrayList<String>();

        final LineNumberReader in = new LineNumberReader(new FileReader(child));
        String line;
        while ((line = in.readLine()) != null) {
            line = line.trim();
            if (line.startsWith("@synthesize ")) {
                variables.add(line.substring("@synthesize ".length(), line.length() - 1));
            }
        }

        return Collections.unmodifiableList(variables);
    }
}

class StreamGobbler extends Thread {
    private final InputStream is;

    StreamGobbler(final InputStream is) {
        this.is = is;
    }

    @Override
    public void run() {
        try {
            final InputStreamReader isr = new InputStreamReader(is);
            final BufferedReader br = new BufferedReader(isr);

            while (br.readLine() != null) {
            }
        } catch (IOException ioe) {
            throw new RuntimeException(ioe);
        }
    }
}