(function ($) {
	var azureHeaderAPIServer = 'https://azure.microsoft.com/';
	var azureHeaderAPIPath = '/asset/header/';
	var azureJsAPIServer = 'https://azure.microsoft.com/';
	var azureJsAPIPath = '/asset/menujs/';
	var headerHolderClass = 'azure-header_temp';

	var userLocale = msDocs.data.userLocale;
	if(userLocale === 'ar-sa' || userLocale === 'he-il'){
		userLocale = 'en-us';
	}

	var azureHeaderAPI = azureHeaderAPIServer + userLocale + azureHeaderAPIPath;
	var azureJsAPI = azureJsAPIServer + userLocale + azureJsAPIPath;

	var getHeader = $.get(azureHeaderAPI);
	var getJs = $.get({
			url: azureJsAPI,
			dataType: 'text'
		});

	$.when(getHeader, getJs).done(function(headerHTML, headerJs){
		$(function(){
			$('.' + headerHolderClass).replaceWith(headerHTML[0]);
			//yep, eval :)
			eval(headerJs[0]);
		});
	});

})(jQuery);