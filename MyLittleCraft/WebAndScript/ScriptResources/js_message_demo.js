var title = document.getElementsByTagName("title")[0].textContent;
window.webkit.messageHandlers.didFindTitle.postMessage(title);
