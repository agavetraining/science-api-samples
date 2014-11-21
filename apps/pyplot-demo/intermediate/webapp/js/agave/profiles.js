/* Retrieve the user's profile from Agave. This is called once
    at page login and/or page load and cached locally.
*/
var Profile = {
  fetch: function()
  {
    var that = this;
    $.ajax({
        type: "GET",
        url: BASE_URL + "/profiles/v2/me?pretty=true",
        dataType: "json",
        beforeSend: function(xhr) {
            xhr.setRequestHeader('Authorization', 'Bearer ' + Token.get());
            xhr.setRequestHeader('Accept', 'application/json');
            xhr.setRequestHeader('Content-Type', 'application/json');
        }
    })
    .done(function(msg) {
        console.log("Successfully retrieved user profile " + msg.result.id);
        that.set(msg.result.username);
    })
    .fail(function(msg) {
        that.clear();
    });
  },

  clear: function()
  {
    localStorage.removeItem('agaveUsername');
  },

  set: function(username)
  {
    localStorage.setItem('agaveUsername', username);
  },

  /* Retrieves logged in username from local storage */
  get: function()
  {
    return localStorage.getItem("agaveUsername");
  }
};
