<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.InetAddress" %>
<%@ page import="java.time.ZonedDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
  String host;
  try { host = InetAddress.getLocalHost().getCanonicalHostName(); }
  catch (Exception e) { host = "unknown"; }
%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Tomcat smoke test</title>
  <style>
    :root { color-scheme: light dark; }
    body { font: 15px/1.55 ui-sans-serif, system-ui, -apple-system, sans-serif;
           margin: 0; padding: 2.5rem 1.25rem; background: #fbfaf8; color: #23201d; }
    @media (prefers-color-scheme: dark) { body { background: #17161a; color: #e8e6e3; } }
    main { max-width: 40rem; margin: 0 auto; }
    h1 { font-size: 1.35rem; margin: 0 0 .25rem; letter-spacing: -.01em; }
    p.sub { margin: 0 0 1.75rem; opacity: .62; font-size: .9rem; }
    table { border-collapse: collapse; width: 100%; font-size: .9rem; }
    th, td { text-align: left; padding: .5rem .25rem; border-bottom: 1px solid rgba(128,128,128,.22); }
    th { font-weight: 500; opacity: .62; width: 38%; }
    td { font-family: ui-monospace, SFMono-Regular, Menlo, monospace; word-break: break-word; }
    .ok { color: #1a7f4b; } .warn { color: #a8620a; }
    @media (prefers-color-scheme: dark) { .ok { color: #5fd398; } .warn { color: #e0a458; } }
  </style>
</head>
<body>
<main>
  <h1>Tomcat is serving this page</h1>
  <p class="sub">Rendered by Jasper from a JSP, so the container compiled it at request time.</p>
  <table>
    <tr><th>Host</th><td><%= host %></td></tr>
    <tr><th>Container</th><td><%= application.getServerInfo() %></td></tr>
    <tr><th>Servlet spec</th><td><%= application.getMajorVersion() %>.<%= application.getMinorVersion() %></td></tr>
    <tr><th>JVM</th><td><%= System.getProperty("java.vm.name") %> <%= System.getProperty("java.version") %></td></tr>
    <tr><th>Connector</th><td><%= request.getScheme() %> on port <%= request.getServerPort() %></td></tr>
    <tr><th>Encrypted</th>
        <td class="<%= request.isSecure() ? "ok" : "warn" %>">
          <%= request.isSecure() ? "yes — TLS" : "no — plaintext" %>
        </td></tr>
    <tr><th>Context path</th><td><%= request.getContextPath() %>/</td></tr>
    <tr><th>Generated</th><td><%= ZonedDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss z")) %></td></tr>
  </table>
</main>
</body>
</html>
