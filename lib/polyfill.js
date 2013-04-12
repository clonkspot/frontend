/* Polyfill for String.startsWith */

// https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/String/startsWith
if (!String.prototype.startsWith) {
  Object.defineProperty(String.prototype, 'startsWith', {
	enumerable: false,
	configurable: false,
	writable: false,
	value: function (searchString, position) {
	  position = position || 0;
	  return this.indexOf(searchString, position) === position;
	}
  });
}
