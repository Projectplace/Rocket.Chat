RocketChat.Migrations.add({
	version: 110,
	up() {
    const rootUserName = 'pproot';
    const rootUserPassword = 'xeroxero';
    const rootUserEmail = 'pproot@planview.com';
    const rootUserFullName = 'PP Chat root';

    const ppuser = RocketChat.models.Users.findOneByUsername(rootUserName);
    
    if (!ppuser) {
      const userData = {
        name: rootUserFullName,
        username: rootUserName,
        password: rootUserPassword,
        email: rootUserEmail,
        active: true,
        roles: ['admin'],
        joinDefaultChannels: false,
        requirePasswordChange: false,
        sendWelcomeEmail: false,
        verified: true
      };

      // insert user
      const createUser = {
        username: userData.username,
        password: userData.password,
        joinDefaultChannels: userData.joinDefaultChannels
      };

      createUser.email = userData.email;

      const _id = Accounts.createUser(createUser);

      const updateUser = {
        $set: {
          name: userData.name,
          roles: userData.roles || ['user'],
          settings: userData.settings || {}
        }
      };
      updateUser.$set.requirePasswordChange = userData.requirePasswordChange;
      updateUser.$set['emails.0.verified'] = userData.verified;
      Meteor.users.update({ _id }, updateUser);
    }
	}
});
