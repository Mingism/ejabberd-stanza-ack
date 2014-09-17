ejabberd stanza ack v0.6
=========

This module will send a confirmation/acknowledgement message to your sender when your message has been received by the ejabberd server and another confirmation/acknowledgement message when your message has been received by the recipient of the message. It provides the same functionality in this regard as the mobile chat app "WhatsApp".

Installation instructions
---------
* First we need to compile this .erl file into a .beam file by running the following command:

    erlc -I ${EJABBERD_SRC} mod_stanza_ack.erl

    {EJABBERD_SRC} must be replaced with the actual location of your ejabberd source files, e.g. /home/foobar/ejabberd/src.     An example of this folder can be found at https://github.com/processone/ejabberd/tree/13.03-beta1/src

* Move the compiled .beam file to the ebin folder of ejabberd (e.g. /lib/ejabberd/ebin) using the following command:

    mv mod_stanza_ack.beam /lib/ejabberd/ebin

* Add the module to the ejabberd.cfg to the existing list of modules:

    {mod_stanza_ack,  [{host, "foobar.com"}]}

* Restart ejabberd:

    ejabberdctl restart

Compatibility
---------
This is an ejabberd module for ejabberd 13.xx 

Version history
---------
mod_stanza_ack v0.6 
Added license information

mod_stanza_ack v0.5 (initial release)
Implements and extends XEP-0184 message receipts:
This module will send message acknowledgements on behalf of the recipient and also on behalf of the server.

License
---------
Copyright (c) 2013-Present Kay Tsar.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
