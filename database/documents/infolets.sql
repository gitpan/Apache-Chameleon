#### Infolets ####
INSERT INTO Documents VALUES (
'', 
'/infolets/user/login.html',
'Login',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% IF user.username != "guest" %]
<table border=0 width=100%>
<tr><th>[% user.realname %] ([% user.username %])</th></tr>
<tr><td>
<a href="/tasks/user/password.html">Lost your password?</a><br>
<a href="/tasks/user/update.html">Update your details</a><br>
<a href="/tasks/user/customise.html">Customise!</a><br>
<a href="/tasks/theme/change.html">Change theme</a><br>
<a href="/tasks/user/reset.html">Reset customisations</a><br>
<a href="/tasks/user/logout.html">Logout</a><br>

</td></tr>
</table>
[% ELSE %]
<table border=0 width=100%>
<tr><th>Login</th></tr>
<tr><td>

<form name="loginform" method="post" action="/tasks/user/login.html">
<table width="100%" border="0" cellpadding="5">
  <tr>
    <td>Username:</td>
    <td><input type="text" name="username" size="10"></td>
  </tr>
  <tr>
    <td>Password:</td>
    <td><input type="password" name="password" size="10"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="login" value="Login"></td>
  </tr>
</table>
</form>
<a href="/tasks/user/create.html">Create a User</a><br>
<a href="/tasks/user/password.html">Lost your password?</a><br>

</td></tr>
</table>
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/infolets/navigation/sidebar.html',
'Navigation',
'0',
'1',
'',
'',
'',
'1',
'0',
'
<table border=0 width=100%>
<tr><th>Navigation</th></tr>
<tr><td>
<a href="/">Home</a><br>
<a href="/tasks/user/index.html">Users</a><br>
<a href="/tasks/document/index.html">Documents</a><br>
<a href="/tasks/theme/index.html">Themes</a><br>
<a href="/news/index.html">News</a><br>
</td></tr>
</table>
');

INSERT INTO Documents VALUES (
'', 
'/infolets/user/loggedin.html',
'Users',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE User %]
<table border=0 width=100%>
<tr><th>Users</th></tr>
<tr><td>
Current users:<br>
[% FOREACH u = User.logged_in %]
<a href="/tasks/user/details.html?userdetails=[% u %]">[% u %]</a><br>
[% END %]
</td></tr>
</table>
');
