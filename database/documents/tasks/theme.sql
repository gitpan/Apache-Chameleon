#### theme ####
INSERT INTO Documents VALUES (
'', 
'/tasks/theme/index.html',
'Tasks: Theme',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
<h1>[% title %]</h1>
<a href="/tasks/theme/create.html">Create a theme</a><br>
<a href="/tasks/theme/update.html">Update a theme</a><br>
<a href="/tasks/theme/delete.html">Delete a theme</a><br>
<a href="/tasks/theme/change.html">Change your theme</a><br>
');

INSERT INTO Documents VALUES (
'', 
'/tasks/theme/create.html',
'Create a Theme',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE Theme %]
[% Theme.create %]
<h1>[% title %]</h1>
[% IF Theme.success %]
[% Theme.success %]
[% ELSE %]
[% IF Theme.error %]
<em>There was an error. 
[% Theme.error %] 
<br>
Please try again</em>
<hr>
<br>
[% Theme.warn %]
[% Theme.info %]
[% END %]

<form name="createthemeform" method="post" action="/tasks/theme/create.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Name: </td>
    <td><input type="text" name="name" size="20" value="[%
    theme.req_parameters.param("name", "Untitled theme") %]"></td>
  </tr>
  <tr>
    <td>Header: </td>
    <td><input type="text" name="header" size="20" value="[% 
    theme.req_parameters.param("header", "/") %]"></td>
  </tr>
  <tr>
    <td>Footer: </td>
    <td><input type="text" name="footer" size="20" value="[% 
    theme.req_parameters.param("path", "/") %]"></td>
  </tr>
  <tr>
    <td>Config: </td>
    <td><input type="text" name="config" size="20" value="[% 
    theme.req_parameters.param("path", "/") %]"></td>
  </tr>
  <tr>
    <td>Description: </td>
    <td><textarea name="description" rows="25" columns="80">[% 
    theme.req_parameters.param("description") %]</textarea></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
    <input type="submit" name="createtheme" value="Create">
</td>
  </tr>
</table>
</form>
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/theme/update.html',
'Update a Theme',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% BLOCK success %]
[% Theme.success %]
[% END %]

[% BLOCK get %]
<form name="getupdatethemeform" method="post" action="/tasks/theme/update.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Name: </td>

    <td>
[% USE Theme %]
<select name="getname">
[% FOREACH t = Theme.list %]
[% t %]
<option value="[% t %]" [% IF t == tag.value %] selected="selected" [%
END %]>[% t %]</option>
[% END %]
</select>
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="getupdatetheme" value="Update"></td>
  </tr>
</table>
</form>
[% END %]

[% BLOCK update %]
<form name="updatethemeform" method="post" action="/tasks/theme/update.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Name: </td>
    <td><input type="text" name="name" size="20" value="[%
    update.name
    %]"></td>
  </tr>
  <tr>
    <td>Header: </td>
    <td><input type="text" name="header" size="20" value="[% 
    update.header
    %]"></td>
  </tr>
  <tr>
    <td>Footer: </td>
    <td><input type="text" name="footer" size="20" value="[% 
    update.footer
    %]"></td>
  </tr>
  <tr>
    <td>Config: </td>
    <td><input type="text" name="config" size="20" value="[% 
    update.config
    %]"></td>
  </tr>
  <tr>
    <td>Description: </td>
    <td><textarea name="description" rows="25" columns="80">[% 
    update.description
    %]</textarea></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
    <input type="submit" name="updatetheme" value="Update">
</td>
  </tr>
</table>
</form>
[% END %]

[% USE Theme %]
<h1>[% title %]</h1>
[% INCLUDE $Theme.update %]
[% IF Theme.error %]
<em>There was an error. 
[% Theme.error %] 
<br>
Please try again</em>
<hr>
<br>
[% Theme.warn %]
[% Theme.info %]
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/theme/delete.html',
'Delete a Theme',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE Theme %]
[% Theme.delete %]
<h1>[% title %]</h1>
[% IF Theme.success %]
[% Theme.success %]
[% ELSE %]
[% IF Theme.error %]
<em>There was an error. 
[% Theme.error %] 
<br>
Please try again</em>
<hr>
<br>
[% END %]
[% Theme.warn %]
[% Theme.info %]

<form name="deletethemeform" method="post" action="/tasks/theme/delete.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Name: </td>
    <td><input type="text" name="name" size="20"></td>
  </tr>
  <tr>
    <td>Repeat name: </td>
    <td><input type="text" name="repeatname" size="20"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
    <input type="submit" name="deletetheme" value="Delete"></td>
  </tr>
</table>
</form>
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/theme/change.html',
'Change Theme',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE User %]
[% User.customise %]
<h1>[% title %]</h1>
[% IF User.success %]
[% User.success %]
[% ELSE %]
[% IF User.error %]
<em>There was an error. 
[% User.error %] 
<br>
Please try again</em>
<hr>
<br>
[% END %]
[% User.warn %] 
[% User.info %] 

<form name="customiseuserform" method="post" action="/tasks/theme/change.html">
<table class=main width="100%" border="0" cellpadding="5">
[% FOREACH tag = user.preferences.get_by_type("theme") %]
  <tr>
    <td><b>Theme</b></td>
    <td>
[% USE Theme %]
<select name="pref_[% tag.pref_id %]">
[% FOREACH t = Theme.list %]
[% t %]
<option value="[% t %]" [% IF t == tag.value %] selected="selected" [%
END %]>[% t %]</option>
[% END %]
</select>
    </td>
  </tr>
[% END %]


  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="customiseuser" value="Customise"></td>
  </tr>
</table>
</form>
Reset your customisations <a href="/tasks/user/reset.html">here</a>
[% END %]
');
