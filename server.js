const express = require('express');
const bodyParser = require('body-parser');
const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(bodyParser.json());

const AUTH_TOKEN = process.env.AUTH_TOKEN || 'change-me-to-a-strong-token';
const SCRIPT = path.join(__dirname, 'run_verus.sh');
const LOGFILE = path.join(__dirname, 'verusminer.log');

let minerProc = null;

function auth(req, res, next) {
  const token = req.headers['x-auth-token'] || req.query.token;
  if (!token || token !== AUTH_TOKEN) return res.status(401).json({ error: 'unauthorized' });
  next();
}

app.post('/start', auth, (req, res) => {
  if (minerProc) return res.status(400).json({ error: 'already running' });

  minerProc = spawn('bash', [SCRIPT], {
    cwd: __dirname,
    detached: false,
    stdio: ['ignore', 'pipe', 'pipe']
  });

  const out = fs.createWriteStream(LOGFILE, { flags: 'a' });
  minerProc.stdout.pipe(out);
  minerProc.stderr.pipe(out);

  minerProc.on('exit', (code) => { minerProc = null; });

  res.json({ status: 'started' });
});

app.post('/stop', auth, (req, res) => {
  if (!minerProc) return res.json({ status: 'not running' });
  minerProc.kill('SIGTERM');
  res.json({ status: 'stopping' });
});

app.get('/status', auth, (req, res) => {
  res.json({ running: !!minerProc });
});

app.get('/log', auth, (req, res) => {
  if (!fs.existsSync(LOGFILE)) return res.send("");
  const data = fs.readFileSync(LOGFILE, 'utf-8');
  res.setHeader('Content-Type', 'text/plain');
  res.send(data);
});

app.get('/health', (req, res) => res.send('ok'));

app.listen(process.env.PORT || 3000);
