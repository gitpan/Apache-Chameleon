#### User tasks ####
INSERT INTO Documents VALUES (
'', 
'/tasks/user/index.html',
'Tasks: User',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
<h1>[% title %]</h1>
<a href="/tasks/user/login.html">Login</a><br>
<a href="/tasks/user/create.html">Create a user</a><br>
<a href="/tasks/user/activation.html">Activate an account</a><br>
<a href="/tasks/user/password.html">Password reminder</a><br>
<a href="/tasks/user/details.html">View a user''s details</a><br>
<br>
<a href="/tasks/user/update.html">Update your details</a><br>
<a href="/tasks/user/customise.html">Customise!</a><br>
<a href="/tasks/user/reset.html">Reset customisations</a><br>
<a href="/tasks/user/logout.html">Logout</a><br>
');

INSERT INTO Documents VALUES (
'', 
'/tasks/user/login.html',
'Login',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE User %]
[% User.login %]
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

<form name="loginform" method="post" action="/tasks/user/login.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Username: </td>
    <td><input type="text" name="username" size="10" value="[%
    User.req_parameters.param("username") 
    %]"></td>
  </tr>
  <tr>
    <td>Password: </td>
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
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/user/logout.html',
'Logout',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE User %]
[% User.logout %]
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

<form name="logoutform" method="post" action="/tasks/user/logout.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Click here to log out:</td>
    <td><input type="submit" name="logout" value="Logout"></td>
  </tr>
</table>
</form>
<a href="/tasks/user/password.html">Lost your password?</a><br>
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/user/create.html',
'Create a new user',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE User %]
[% User.create %]
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

<form name="createuserform" method="post" action="/tasks/user/create.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Username: </td>
    <td><input type="text" name="username" size="10" value="[%
    User.req_parameters.param("username") %]"></td>
  </tr>
  <tr>
    <td>Password: </td>
    <td><input type="password" name="password" size="10"></td>
  </tr>
  <tr>
    <td>Repeat Password: </td>
    <td><input type="password" name="repeat_password" size="10"></td>
  </tr>
  <tr>
    <td>Email address: </td>
    <td><input type="text" name="email" size="10" value="[%
    User.req_parameters.param("email") %]"></td>
  </tr>
  <tr>
    <td>Real Name: </td>
    <td><input type="text" name="realname" size="10" value="[%
    User.req_parameters.param("realname") %]"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="create_user" value="Create"></td>
  </tr>
</table>
</form>
<a href="/tasks/user/activation.html">Activate your account</a><br>
<a href="/tasks/user/password.html">Lost your password?</a><br>
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/user/update.html',
'Update user',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE User %]
[% User.update %]
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

<form name="updateuserform" method="post" action="/tasks/user/update.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Username: </td>
    <td>[% user.username %]</td>
  </tr>
  <tr>
    <td>Current Password: </td>
    <td><input type="password" name="currentpassword" size="10"></td>
  </tr>
  <tr>
    <td>New Password: </td>
    <td><input type="password" name="newpassword" size="10"></td>
  </tr>
  <tr>
    <td>Repeat New Password: </td>
    <td><input type="password" name="newpasswordrepeat" size="10"></td>
  </tr>
  <tr>
    <td>Email address: </td>
    <td><input type="text" name="email" size="10" value="[% 
    user.email
    %]"></td>
  </tr>
  <tr>
    <td>Real Name: </td>
    <td><input type="text" name="realname" size="10" value="[% 
    user.realname
    %]"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="updateuser" value="Update"></td>
  </tr>
</table>
</form>
<a href="/tasks/user/password.html">Lost your password?</a><br>
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/user/details.html',
'View User Details',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE User %]
[% User.details %]
<h1>[% title %]</h1>
[% IF User.success %]
[% User.success %]
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Username: </td>
    <td>
    [% viewuserdetails.username %]
    </td>
  </tr>
  <tr>
    <td>Real name: </td>
    <td>
    [% viewuserdetails.realname %]
    </td>
  </tr>
  <tr>
    <td>Email: </td>
    <td>
    [% viewuserdetails.email %]
    </td>
  </tr>
  <tr>
    <td>Last login: </td>
    <td>
    [% viewuserdetails.last_access %]
    </td>
  </tr>
  <tr>
    <td>User since: </td>
    <td>
    [% viewuserdetails.created %]
    </td>
  </tr>
  <tr>
    <td>Status: </td>
    <td>
    [% viewuserdetails.status %]
    </td>
  </tr>
  <tr>
    <td>IP Address: </td>
    <td>
    [% viewuserdetails.last_ip_address %]
    </td>
  </tr>
</table>
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

<form name="userdetailsform" method="post" action="/tasks/user/details.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Username: </td>
    <td>
    <input type="text" name="userdetails" size="20">
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="viewuserdetails" value="Details"></td>
  </tr>
</table>
</form>
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/user/customise.html',
'Customise',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% BLOCK ffamily %]
<select name="pref_[% tag.pref_id %]">
[% FOREACH f = [ 
"Verdana, Arial, Helvetica, sans-serif",
"Geneva, Arial, Helvetica, san-serif"
"Arial, Helvetica, sans-serif",
"Times New Roman, Times, serif",
"Courier New, Courier, mono",
] %]
<option value="[% f %]" [% IF f == tag.value %] selected="selected" [%
END %]>[% f %]</option>
[% END %]
</select>
[% END %]

[% BLOCK fsize %]
<select name="pref_[% tag.pref_id %]">
[% FOREACH f = [ "0.5em", "0.6em", "0.7em", "0.8em", "0.9em", "1.0em",
"1.1em", "1.2em", "1.3em", "1.4em", "1.5em", ] %]
<option value="[% f %]" [% IF f == tag.value %] selected="selected" [%
END %]>[% f %]</option>
[% END %]
</select>
[% END %]
[% BLOCK colour %]
<select name="pref_[% tag.pref_id %]">
[%
colours.aquamarine = "#7FFFD4";
colours.azure = "#F0FFFF";
colours.beige = "#F5F5DC";
colours.bisque = "#FFE4C4";
colours.black = "#000000";
colours.blue = "#0000FF";
colours.brown = "#A52A2A";
colours.burlywood = "#DEB887";
colours.chartreuse = "#7FFF00";
colours.chocolate = "#D2691E";
colours.coral = "#FF7F50";
colours.cornsilk = "#FFF8DC";
colours.cyan = "#00FFFF";
colours.firebrick = "#B22222";
colours.gainsboro = "#DCDCDC";
colours.gold = "#FFD700";
colours.goldenrod = "#DAA520";
colours.gray = "#BEBEBE";
colours.green = "#00FF00";
colours.honeydew = "#F0FFF0";
colours.ivory = "#FFFFF0";
colours.khaki = "#F0E68C";
colours.lavender = "#E6E6FA";
colours.lawn_green = "#7CFC00";
colours.light_green = "#DDFFDD";
colours.light_blue= "#76CBF2";
colours.linen = "#FAF0E6";
colours.magenta = "#FF00FF";
colours.maroon = "#B03060";
colours.moccasin = "#FFE4B5";
colours.orange = "#FFA500";
colours.orchid = "#DA70D6";
colours.peru = "#CD853F";
colours.pink = "#FFC0CB";
colours.plum = "#DDA0DD";
colours.purple = "#A020F0";
colours.red = "#FF0000";
colours.salmon = "#FA8072";
colours.seashell = "#FFF5EE";
colours.sienna = "#A0522D";
colours.subtle_green = "#9FF276";
colours.tan = "#D2B48C";
colours.thistle = "#D8BFD8";
colours.tomato = "#FF6347";
colours.turquoise = "#40E0D0";
colours.violet = "#EE82EE";
colours.wheat = "#F5DEB3";
colours.white = "#FFFFFF";
colours.yellow = "#FFFF00";
%]
[% FOREACH c = colours.keys.sort %]
<option name="[% c %]" value="[% colours.$c %]" [% 
IF colours.$c == tag.value %] selected="selected" [% END %]>[% c %]</option>
[% END %]
</select>
[% END %]

[% BLOCK defblock %]
<input type="text" name="pref_[% tag.pref_id %]" size="20" 
       value="[% tag.value %]">
[% END %]

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

<form name="customiseuserform" method="post" 
    action="/tasks/user/customise.html">
<table class=main width="100%" border="0" cellpadding="5">
[% option = user.preferences.list_selectors;
FOREACH o = option.keys;
IF o.length > 0 %]
[% t = user.preferences.get_by_type("CSS", o) %]
  <tr>
    <td><b>[% t.0.description %]</b>
    <td>&nbsp;</td>
  </tr>
[% FOREACH tag = t %]
[% SWITCH tag.property %]
[% CASE "font-family" %]
[% caption = "Font family" %]
[% blk = "ffamily" %]
[% CASE "font-size" %]
[% caption = "Font size" %]
[% blk = "fsize" %]
[% CASE "font-color" %]
[% caption = "Font colour" %]
[% blk = "colour" %]
[% CASE "color" %]
[% caption = "Font colour" %]
[% blk = "colour" %]
[% CASE "background-color" %]
[% caption = "Colour" %]
[% blk = "colour" %]
[% CASE DEFAULT %]
[% caption = tag.property %]
[% blk = "defblock" %]
[% END %]
<tr>
  <td>[% caption %]:</td>
  <td align="right">[% INCLUDE $blk %]</td>
  </tr>
[% END %]
[% END %]
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

INSERT INTO Documents VALUES (
'', 
'/tasks/user/alt-customise.html',
'Customise',
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

<form name="customiseuserform" method="post" action="/tasks/user/customise.html">
<table class=main width="100%" border="0" cellpadding="5">
[% FOREACH tag = user.preferences.get %]
[% NEXT IF tag.description == "Theme" %]
  <tr>
    <td><b>[% tag.description %]</b>
    [% tag.selector %] [% tag.property %]</td>
    <td><input type="text" name="pref_[% tag.pref_id %]" size="40" value="[% 
    tag.value %]"></td>
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

INSERT INTO Documents VALUES (
'', 
'/tasks/user/activation.html',
'Account Activation',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE User %]
[% User.activate %]
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

<form name="activationform" method="post" action="/tasks/user/activation.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Username: </td>
    <td><input type="text" name="username" size="10" value="[%
    User.req_parameters.param("username")
    %]"></td>
  </tr>
  <tr>
    <td>Activation code: </td>
    <td><input type="text" name="activation" size="20" value="[%
    User.req_parameters.param("activation")
    %]"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="activatebutton" value="Activate"></td>
  </tr>
</table>
</form>
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/user/password.html',
'Lost Password',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE User %]
[% User.password %]
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

Filling in this form will send your password back to you via email.<br>
You must fill in both fields.<br>
<form name="userpasswordform" method="post"
action="/tasks/user/password.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Username: </td>
    <td><input type="text" name="username" size="10" value="[% 
    User.req_parameters.param("username")
    %]"></td>
  </tr>
  <tr>
    <td>Email address: </td>
    <td><input type="text" name="email" size="10" value="[% 
    User.req_parameters.param("email")
    %]"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="user_password" value="Send"></td>
  </tr>
</table>
</form>
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/user/reset.html',
'Reset Customisations',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE User %]
[% User.reset %]
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

<form name="resetform" method="post" action="/tasks/user/reset.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Click here to reset customisations:</td>
    <td><input type="submit" name="reset_preferences" value="Reset"></td>
  </tr>
</table>
</form>
<a href="/tasks/user/customise.html">Customise</a><br>
[% END %]
');
