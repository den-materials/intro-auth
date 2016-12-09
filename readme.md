![](https://ga-dash.s3.amazonaws.com/production/assets/logo-9f88ae6c9c3871690e33280fcf557f33.png)

<!--11:00 10 minutes -->

<!-- Hook: So why do we think coders often neglect security?

One of the main reasons is "it takes too much time".  Well, today we'll show you a Node library that takes care of it for us, so we don't need to spend all that time.  Today, we'll talk about authentication, but specifically, we'll be using bCrypt and Passport to take some of that responsibility off our shoulders so all we need to do with the latest, greatest security hole that shows up is...upgrade to the latest version and exhale. -->

# Authentication with Javascript

### Why is this important?
<!-- framing the "why" in big-picture/real world examples -->
*This workshop is important because:*

Authenticating users is key to authorizing who is allowed to do what in an application. We need to implement these concepts in order to create differentiated user experiences on the application. For example, when we go to Twitter, we'd like to see new tweets customized for each of our profiles, and when other people go to gmail, we'd like them prevented from accessing our emails. 

### What are the objectives?
<!-- specific/measurable goal for students to achieve -->
*After this workshop, developers will be able to:*

* **Describe** an authentication system that securely stores users' passwords
* **Describe** the role that BCrypt plays in authentication

### Where should we be now?
<!-- call out the skills that are prerequisites -->
*Before this workshop, developers should already be able to:*

* **Illustrate** the request/response cycle
* **Build** an MVC Javascript application

## Authentication / Authorization

* **Authentication** verifies that a user is who they say they are. When a user logs into our site, we *authenticate* them by checking that the password they typed in matches the password we have stored for them.
* **Authorization** is the process of determining whether or not a user has *permission* to to perform certain actions on our site. For example, a user may *be authorized* to view their profile page and edit their own blog posts, but not to edit another user's blog posts.

A user must always first be authenticated, then it can be determined what they are authorized to do.

>Example: When Sarah enters a bar, a bouncer looks at her photo ID to ensure (authenticate) that she is who she claims. Sarah is thirty years old, so she is allowed (authorized) to drink.

<!--11:10 10 minutes -->

<!-- Imprivata example with fingerprints: so first, you say you are Dr. Murphy.  Is this Dr. Murphy's fingerprint?  No?  Sorry Dr. Stevens, nice try.  Go get Dr. Murphy and try again.  OK, that's Dr. Murphy.  You are "authenticated".  You want to sign a prescription?  Go for it, you are "authorized" for that.  An hour later...OK, this person is saying they are *Nurse* Murphy.  Is this their fingerprint?  Yes, they are "authenticated".  You want to sign a prescription?  Ummm, you're not a doctor, you're not "authorized" for that.  Nice try.-->

<!-- Catch-phrase authentication and authorization -->

<!--11:15 actually -->

<!--11:20 15 minutes -->

## Password Hashing

First, let's see [how not to store a password](https://www.youtube.com/watch?v=8ZtInClXe1Q).

In order to authenticate a user, we need to store their password in our database. This allows us to check that the user typed in the correct password when logging into our site.

The downside is that if anyone ever got access to our database, they would also have access to all of our users' login information. We use a [**hashing algorithm**](https://crackstation.net/hashing-security.htm#normalhashing) to avoid storing plain-text passwords in the database. We also use a [**salt**](https://crackstation.net/hashing-security.htm#salt) to randomize the hashing algorithm, providing extra security against potential attacks. The plain-text password that has been hashed can be referred to as the **password digest**.

Think of a digested password as a firework. It is very easy to explode a firework (*hash plaintext into a digest*), but next to impossible to reverse that process (*turn the digest back into plaintext*). If I wanted to see if two sets of fireworks are the same (*a user is logging in, aka has provided their password and wishes to be authenticated*) we have to explode the fireworks again to compare it with the original explosion (*take the provided plaintext password, hash it again using the same algorithm, and match it with the saved password digest*).

![fireworks](http://i.giphy.com/122XXtx3oumxBm.gif)

<!--11:35 10 minutes -->

<!--Math explanation/simplification on board of SHA-1

Something like take a password, convert it to binary, break it up into three words of 8 bits, and then do something like (A&&B||C for digit 1, A||B&&C for digit 2, A&&B&&C for digit 3, etc.)
-->

<!--11:45 20 minutes -->

## BCrypt

The library of choice for password hashing is `BCrypt`, which we will add to our `node` project.

Remember, remember: **never store plaintext passwords**, only the digested versions. 

### Playing With `BCrypt`

<!--11:44 when turning over to devs, math explanation took a while, other stuff was fast -->

Let's create a new project to test `BCrypt`.  This will require us to:

- Make a new directory
- Go inside the directory and set it up as an `npm` project and install the `bcrypt` package
- Create a `server.js` file
- Require `bcrypt` at the top of `server.js`

Now let's show how bcrypt creates a hashed digest of a password, and how it can test for equality of our "exploded password fireworks".

<!--bCrypt is really bad at requiring a WHOLE BUNCH of stuff for configuration (python EVN variables, command-line tools)-->

First, we should create two passwords.

<!--
const myPassword = 'not_bacon';
const otherPassword = 'bacon';-->

Next, we need to generate a salt.  We will do this with bcrypt's `genSalt()` function.

<!--
bcrypt.genSalt(function(err, salt) {
	console.log("Salt: " + salt);
}); -->

Then, we need to generate a hash for our password, mixing the salt with our password before we do so.

<!--
bcrypt.hash(myPassword, salt, function(err, hash) {
    console.log("Salty hash: " + hash);
}); -->

<!--12:09 actually holy shit bcrypt laying down on the job, are you?  so many things breaking dev's projects -->

Finally, let's check to see if our "exploded firework" matches our original password if we "explode" (hash) it again.  While we're at it, let's check to make sure it *doesn't* match our other password.

<!--
bcrypt.compare(myPassword, hash, function(err, res) {
    console.log("My password and hash match: " + res);
});
bcrypt.compare(otherPassword, hash, function(err, res) {
    console.log("Other password and hash match: " + res);
});		-->

<details>
<summary>Sample code</summary>
```js
const bcrypt = require('bcrypt');
const myPassword = 'not_bacon';
const otherPassword = 'bacon';

bcrypt.genSalt(function(err, salt) {
	console.log("Salt: " + salt);
  bcrypt.hash(myPassword, salt, function(err, hash) {
      console.log("Salty hash: " + hash);
      bcrypt.compare(myPassword, hash, function(err, res) {
			    console.log("My password and hash match: " + res);
			});
      bcrypt.compare(otherPassword, hash, function(err, res) {
			    console.log("Other password and hash match: " + res);
			});				
  });
});
```
</details>

How will BCrypt's compare method help us **authenticate** a `User`?

[BCrypt](https://en.wikipedia.org/wiki/Bcrypt) uses a ["salt"](https://en.wikipedia.org/wiki/Salt_(cryptography)) to protect against [rainbow table](https://en.wikipedia.org/wiki/Rainbow_table) attacks and is an [adaptive function](https://codiscope.com/cryptographic-hash-functions/) (see section: "Adaptive Hash Functions") to protect against [brute-force](https://en.wikipedia.org/wiki/Brute-force_search) attacks.

<!-- Catch-phrase with encryption, hash, salt, bcrypt -->

<!--12:05 5 minutes -->

## Closing Thoughts

* What is the difference between authorization and authentication?
* How should we not store passwords?
* Why is BCrypt useful and how do we use it to authenticate a user
* How do salts work with hashing?

<!--12:33-->

## Additional Resources

<!--Note youtube link below says 42 meaning 46, but otherwise solid-->
* [How public-key cryptosystems work](https://www.youtube.com/watch?v=3QnD2c4Xovk)
