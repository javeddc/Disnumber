console.log('yo');

var dis = {
  userInput: document.getElementById('user_input'),
  inputLabel: document.getElementById('input_label'),
  findBtn: document.getElementById('find_btn'),
  inputAlert: document.getElementById('input_label'),
  copyPhraseBtn: document.getElementById('copy_phrase'),
  copyDigitsBtn: document.getElementById('copy_digits'),
  phraseText: document.getElementById('phrase_text'),
  digitsText: document.getElementById('digits_text'),
  alertBox: document.getElementById('notification'),
  alertText: document.getElementById('notification_text'),
  check_input: function() {
    console.log('beep');
    text = dis.userInput.value;
    text = text.replace(/-|,|\.|_/, ' ');
    if (text.replace(/[^A-Za-z\d +#*-\.]/g, '') != text) {
      dis.inputAlert.textContent = 'Enter letters, numbers or # * + -';
      dis.inputAlert.style.visibility = 'visible';
      dis.inputAlert.style.color = 'orange';
      dis.btn_off();
    } else if ((/\d|\*/g).test(text) && ((/[a-z]/ig).test(text))) {
      dis.inputAlert.textContent = 'Please enter a number OR a phrase!';
      dis.inputAlert.style.visibility = 'visible';
      dis.inputAlert.style.color = 'orange';
      dis.btn_off()
    } else if (text == '') {
      dis.inputAlert.textContent = 'Search by number or phrase';
      dis.inputAlert.style.color = '#fff';
      dis.btn_off();
    } else {
      dis.inputAlert.textContent = 'Hit enter to search!';
      dis.inputAlert.style.color = '#fff';

      dis.btn_on()
    }

    text = text.replace(/[^A-Za-z\d +#*-]/, '')
    dis.userInput.value = text;

  },
  inputFocus: function(ev) {
    ev.target.parentNode.classList.add('input--filled');
  },
  inputBlur: function(ev) {
    if (ev.target.value.trim() === '') {
      ev.target.parentNode.classList.remove('input--filled');
      dis.inputAlert.textContent = 'Search by Number or Phrase';
      dis.inputAlert.style.visibility = 'visible';
      dis.inputAlert.style.color = 'white';
    }
  },
  btn_on: function() {
    dis.findBtn.disabled = false;
    dis.findBtn.classList.remove('disabled');
  },
  btn_off: function() {
    dis.findBtn.disabled = true;
    dis.findBtn.classList.add('disabled');
  },
  copyToClipboard: function(element) {
    var temp = document.createElement("input");
    temp.setAttribute("value", element.innerHTML);
    document.body.appendChild(temp);
    temp.select();
    document.execCommand("copy");
    document.body.removeChild(temp);
    dis.popMessage('Copied to clipboard: ' + element.innerHTML)
  },
  popMessage(message) {
    dis.alertBox.style.display = 'block';
    dis.alertText.textContent = message;
    setTimeout(function() {
      dis.alertBox.style.display = 'none';
    }, 1400);
  }
}
dis.btn_off();
dis.findBtn.style.display = 'none';
dis.userInput.addEventListener('input', dis.check_input);
dis.userInput.addEventListener('click', dis.inputFocus);
dis.userInput.addEventListener('blur', dis.inputBlur);
dis.inputLabel.addEventListener('click', function() {
  console.log('clicked');
})
dis.copyPhraseBtn.addEventListener('click', function() {
  dis.copyToClipboard(dis.phraseText)
});
dis.copyDigitsBtn.addEventListener('click', function() {
  dis.copyToClipboard(dis.digitsText)
});



console.log('yeh');
