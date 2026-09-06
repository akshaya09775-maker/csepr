const PRIME = 31;
const MOD = 1000000007;

const pwInput = document.getElementById('pwInput');
const dropBtn = document.getElementById('dropBtn');
const stepBtn = document.getElementById('stepBtn');
const resetBtn = document.getElementById('resetBtn');
const speedInput = document.getElementById('speed');
const track = document.getElementById('charTrack');
const reactor = document.getElementById('reactor');
const finalPanel = document.getElementById('finalPanel');

const vChar = document.getElementById('v-char');
const vMul = document.getElementById('v-mul');
const vMod = document.getElementById('v-mod');
const vRunning = document.getElementById('v-running');
const hashBar = document.getElementById('hashBar');
const finalHex = document.getElementById('finalHex');

let pos = 0;
let hash = 7;
let timer = null;
let running = false;

function getPw() {
  return pwInput.value.length ? pwInput.value : 'Cat42!';
}

function renderTrack() {
  const pw = getPw();
  track.innerHTML = '';
  for (let i = 0; i < pw.length; i++) {
    const chip = document.createElement('div');
    chip.className = 'char-chip';
    chip.textContent = pw[i];
    if (i < pos) chip.classList.add('done');
    if (i === pos) chip.classList.add('active');
    chip.id = 'chip-' + i;
    track.appendChild(chip);
  }
}

function setStat(el, value) {
  el.textContent = value;
}

function stepOnce() {
  const pw = getPw();
  if (pos >= pw.length) {
    stopAuto();
    finalHex.textContent = hash.toString(16);
    finalPanel.classList.add('ready');
    return false;
  }

  const ch = pw[pos];
  const code = pw.charCodeAt(pos);
  const multiplied = hash * PRIME;
  hash = (multiplied + code) % MOD;

  setStat(vChar, ch + '  (' + code + ')');
  setStat(vMul, multiplied.toLocaleString());
  setStat(vMod, hash.toLocaleString());
  setStat(vRunning, hash.toLocaleString());

  vRunning.classList.remove('bump');
  void vRunning.offsetWidth;
  vRunning.classList.add('bump');

  reactor.classList.remove('pulse');
  void reactor.offsetWidth;
  reactor.classList.add('pulse');

  const activeChip = document.getElementById('chip-' + pos);
  if (activeChip) {
    activeChip.classList.add('falling');
  }

  const progress = Math.min(100, Math.round(((pos + 1) / pw.length) * 100));
  hashBar.style.width = progress + '%';

  pos++;

  setTimeout(renderTrack, 260);

  if (pos >= pw.length) {
    setTimeout(() => {
      finalHex.textContent = hash.toString(16);
      finalPanel.classList.add('ready');
      stopAuto();
    }, 400);
    return false;
  }
  return true;
}

function reset() {
  stopAuto();
  pos = 0;
  hash = 7;
  setStat(vChar, '—');
  setStat(vMul, '—');
  setStat(vMod, '—');
  setStat(vRunning, '7');
  finalHex.textContent = '—';
  finalPanel.classList.remove('ready');
  hashBar.style.width = '0%';
  renderTrack();
}

function startAuto() {
  if (pos >= getPw().length) reset();
  running = true;
  dropBtn.querySelector('.btn-label').textContent = 'pause';
  tick();
}

function tick() {
  const ok = stepOnce();
  if (ok && running) {
    const delay = parseInt(speedInput.value, 10);
    timer = setTimeout(tick, delay);
  } else {
    running = false;
    dropBtn.querySelector('.btn-label').textContent = 'drop it in';
  }
}

function stopAuto() {
  running = false;
  clearTimeout(timer);
  timer = null;
  dropBtn.querySelector('.btn-label').textContent = 'drop it in';
}

dropBtn.addEventListener('click', () => {
  if (running) {
    stopAuto();
  } else {
    startAuto();
  }
});

stepBtn.addEventListener('click', () => {
  stopAuto();
  stepOnce();
});

resetBtn.addEventListener('click', reset);

pwInput.addEventListener('input', () => {
  reset();
});

renderTrack();
