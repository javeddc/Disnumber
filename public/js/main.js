console.log('yo');

var dis = {
userInput: document.getElementById('user_input'),
findBtn: document.getElementById('find_btn'),
inputAlert: document.getElementById('input_alert'),
check_input: function() {
  console.log('beep');
  text = dis.userInput.value;
  text = text.replace(/-|,|\.|_/, ' ');
  if (text.replace(/[^A-Za-z\d +#*-]/g, '') != text) {
    dis.inputAlert.textContent = 'Please enter letters, numbers, or dialing characters (#*+-)';
    dis.inputAlert.style.visibility = 'visible';
    dis.btn_off()
  } else if ((/\d/g).test(text) && ((/[a-z]/ig).test(text))) {
    dis.inputAlert.textContent = 'Please enter a number OR a phrase';
    dis.inputAlert.style.visibility = 'visible';
    dis.btn_off()
  } else if () {

  } else {
    dis.inputAlert.style.visibility = 'hidden';
    dis.btn_on()
  }

  text = text.replace(/[^A-Za-z\d +#*-]/, '')
  dis.userInput.value = text;
  console.log(text);
  patt = / /
},
btn_on: function() {
  dis.findBtn.disabled = false;
  dis.findBtn.classList.remove('disabled');
},
btn_off: function() {
  dis.findBtn.disabled = true;
  dis.findBtn.classList.add('disabled');
}
}

dis.userInput.addEventListener('input', dis.check_input);
