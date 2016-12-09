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