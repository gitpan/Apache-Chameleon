#### Document ####
INSERT INTO Documents VALUES (
'', 
'/tasks/document/index.html',
'Tasks: Documents',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
<h1>[% title %]</h1>
<a href="/tasks/document/create.html">Create a document</a><br>
<a href="/tasks/document/update.html">Update a document</a><br>
<a href="/tasks/document/delete.html">Delete a document</a><br>
<a href="/tasks/document/list.html">List all documents</a><br>
');

INSERT INTO Documents VALUES (
'', 
'/tasks/document/create.html',
'Create a Document',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE Document %]
[% Document.create %]
<h1>[% title %]</h1>
[% IF Document.success %]
[% Document.success %]
[% ELSE %]
[% IF Document.error %]
<em>There was an error. 
[% Document.error %] 
<br>
Please try again</em>
<hr>
<br>
[% END %]
[% Document.warn %]
[% Document.info %]

<form name="createdocform" method="post" action="/tasks/document/create.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Path: </td>
    <td><input type="text" name="path" size="20" value="[% 
    Document.req_parameters.param("path", "/") %]"></td>
  </tr>
  <tr>
    <td>Title: </td>
    <td><input type="text" name="title" size="20" value="[%
    Document.req_parameters.param("title", "Untitled Document") %]"></td>
  </tr>
<!--  <tr>
    <td>Version: </td>
    <td><input type="text" name="version" size="1"></td>
  </tr>
  <tr>
    <td>Type: </td>
    <td><input type="text" name="type" size="10"></td>
  </tr>
  <tr>
    <td>World Read: </td>
    <td><input type="text" name="worldread" size="1"></td>
  </tr>
  <tr>
    <td>World Write: </td>
    <td><input type="text" name="worldwrite" size="1"></td>
  </tr>
  -->
  <tr>
    <td>Contents: </td>
    <td><textarea name="contents" rows="25" columns="80">[% 
    Document.req_parameters.param("contents") %]</textarea></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
<input type="hidden" name="version" value="0">
<input type="hidden" name="type" value="parsed">
<input type="hidden" name="worldread" value="1">
<input type="hidden" name="worldwrite" value="0">
<input type="submit" name="createdoc" value="Create">
</td>
  </tr>
</table>
</form>
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/document/update.html',
'Update a Document',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% BLOCK success %]
[% Document.success %]
[% END %]

[% BLOCK get %]
<form name="getupdatedocform" method="post" action="/tasks/document/update.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Document path: </td>
    <td><input type="text" name="getpath" size="20" value="[% 
    Document.req_parameters.param("getpath", "/") 
    %]"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="getupdatedoc" value="Update"></td>
  </tr>
</table>
</form>
[% END %]

[% BLOCK update %]
<form name="updatedocform" method="post" action="/tasks/document/update.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Document path: </td>
    <td><input type="text" name="path" size="20" value="[% 
    update.path
    %]"></td>
  </tr>
  <tr>
    <td>Document Title: </td>
    <td><input type="text" name="title" size="20" value="[% 
    update.title
    %]"></td>
  </tr>
<!--  <tr>
    <td>Version: </td>
    <td><input type="text" name="version" size="1" value="[%
    update.version %]"></td>
  </tr>
  <tr>
    <td>Type: </td>
    <td><input type="text" name="doctype" size="10"
    value="[% doctype %]"></td>
  </tr>
  <tr>
    <td>World Read: </td>
    <td><input type="text" name="worldread" size="1"
    value="[% worldread %]"></td>
  </tr>
  <tr>
    <td>World Write: </td>
    <td><input type="text" name="worldwrite" size="1"
    value="[% worldwrite %]"></td>
  </tr>
  -->
  <tr>
    <td>Contents: </td>
    <td><textarea rows="25" columns="80" name="contents">[% 
    update.contents
    %]</textarea></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
    <input type="hidden" name="type" value="parsed">
    <input type="hidden" name="worldread" value="1">
    <input type="hidden" name="worldwrite" value="0">
    <input type="submit" name="updatedoc" value="Update"></td>
  </tr>
</table>
</form>
[% END %]

[% USE Document %]
<h1>[% title %]</h1>
[% INCLUDE $Document.update %]
[% IF Document.error %]
<em>There was an error. 
[% Document.error %] 
<br>
Please try again</em>
<hr>
<br>
[% Document.warn %]
[% Document.info %]
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/document/delete.html',
'Delete a Document',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE Document %]
[% Document.delete %]
<h1>[% title %]</h1>
[% IF Document.success %]
[% Document.success %]
[% ELSE %]
[% IF Document.error %]
<em>There was an error. 
[% Document.error %] 
<br>
Please try again</em>
<hr>
<br>
[% END %]
[% Document.warn %]
[% Document.info %]

<form name="deletedocform" method="post" action="/tasks/document/delete.html">
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td>Path: </td>
    <td><input type="text" name="path" size="20"></td>
  </tr>
  <tr>
    <td>Repeat path: </td>
    <td><input type="text" name="repeatpath" size="20"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
    <input type="hidden" name="version" value="0">
    <input type="submit" name="deletedoc" value="Delete"></td>
  </tr>
</table>
</form>
[% END %]
');

INSERT INTO Documents VALUES (
'', 
'/tasks/document/list.html',
'Document Lister',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
[% USE Document %]
<h1>[% title %]</h1>
[% FOREACH d = Document.list %]
<table class=main width="100%" border="0" cellpadding="5">
  <tr>
    <td align="left">
    [% d.title %]
    </td>
    <td align="right">
    <a href="[% d.path %]">[% d.path %]</a>
    </td>
  </tr>
</table>
</form>
[% END %]
');
