#### Email documents ####
INSERT INTO Documents VALUES (
'', 
'/email/lostpassword.email',
'Lost password reminder',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
Hello [% realname %],
Here are your account details:

Username: [% username %]
Password: [% password %]

Have fun!
Chameleon
');

INSERT INTO Documents VALUES (
'', 
'/email/newuser.email',
'Welcome new user!',
'0',
'1',
'',
'',
'parsed',
'1',
'0',
'
Hello [% realname %],
Here are your account details:

Username:           [% username   %]
Password:           [% password   %]
Email:              [% email      %]
Activation code:    [% activation %]

You must activate your account before you can use it.
To activate your account, go to this URL:
http://[% hostname %][% url %]?username=[% username %]&activation=[% activation %]

or go to:
http://[% hostname %][% url %]

and supply the details given above.

Have fun!
Chameleon
');
