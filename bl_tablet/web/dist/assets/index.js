const { useEffect, useState, useMemo } = React;

const wallpapers = {
  'aurora-orange': 'https://images.unsplash.com/photo-1529333166433-1010dbaefe63?auto=format&fit=crop&w=1600&q=80',
  'midnight-blue': 'https://images.unsplash.com/photo-1527443224154-d28ef00ddd5e?auto=format&fit=crop&w=1600&q=80',
  'graphite': 'https://images.unsplash.com/photo-1485115905815-74a5c9fda2ad?auto=format&fit=crop&w=1600&q=80'
};

const defaultProfile = {
  displayName: "Tablet",
  language: "de",
  theme: "auto",
  accent: "#4e8ef7",
  wallpaper: "aurora-orange",
  settings: {
    autoLock: 5,
    haptics: true,
    biometrics: false
  }
};

function useNuiState() {
  const [deviceId, setDeviceId] = useState(null);
  const [profile, setProfile] = useState(defaultProfile);
  const [setupDone, setSetupDone] = useState(false);
  const [locked, setLocked] = useState(true);
  const [notifications, setNotifications] = useState([]);

  useEffect(() => {
    const handler = (event) => {
      const data = event.data;
      if (!data || !data.action) return;
      if (data.action === 'hydrate') {
        setDeviceId(data.deviceId);
        const serverProfile = data.state.profile;
        if (serverProfile) {
          setProfile({
            displayName: serverProfile.display_name,
            language: serverProfile.language,
            theme: serverProfile.theme,
            accent: serverProfile.accent,
            wallpaper: serverProfile.wallpaper,
            settings: JSON.parse(serverProfile.settings_json || '{}')
          });
          setSetupDone(true);
          setLocked(true);
        }
      }
      if (data.action === 'unlockResult') {
        if (data.success) {
          setLocked(false);
        }
      }
      if (data.action === 'notification') {
        setNotifications((prev) => [{ ...data.payload, id: Date.now() }, ...prev].slice(0, 4));
      }
    };
    window.addEventListener('message', handler);
    return () => window.removeEventListener('message', handler);
  }, []);

  return { deviceId, profile, setProfile, setupDone, setSetupDone, locked, setLocked, notifications, setNotifications };
}

function StatusBar() {
  const now = new Date();
  return (
    <div className="status-bar">
      <div>{now.getHours().toString().padStart(2,'0')}:{now.getMinutes().toString().padStart(2,'0')}</div>
      <div className="indicators">
        <span>5G</span>
        <span>100%</span>
        <span>WiFi</span>
      </div>
    </div>
  );
}

function Lockscreen({ profile, onUnlock, onForgot }) {
  const [pin, setPin] = useState('');
  const date = useMemo(() => new Date(), []);
  return (
    <div className="lockscreen">
      <StatusBar />
      <div className="center-stack">
        <div style={{ fontSize: 62, fontWeight: 700, textShadow: '0 14px 40px rgba(0,0,0,0.35)' }}>{date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</div>
        <div style={{ opacity: 0.9 }}>{date.toLocaleDateString(undefined, { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}</div>
        <div className="lock-avatar"><img src="https://i.pravatar.cc/150" width="72" height="72" /></div>
        <div style={{ fontWeight: 600 }}>{profile.displayName || 'Tablet'}</div>
        <div className="lock-input">
          <input type="password" placeholder="PIN / Passwort" value={pin} onChange={(e) => setPin(e.target.value)} onKeyDown={(e) => e.key === 'Enter' && onUnlock(pin)} />
          <button className="button primary" onClick={() => onUnlock(pin)}>
            Unlock
          </button>
        </div>
        <button className="button" onClick={onForgot} style={{ background: 'transparent', color: '#fff', borderColor: 'rgba(255,255,255,0.35)' }}>Forgot?</button>
      </div>
    </div>
  );
}

function Dock({ apps, onOpen }) {
  return (
    <div className="dock">
      {apps.filter(a => a.dock).map((app) => (
        <div key={app.id} className="app-icon card" style={{ background: 'linear-gradient(145deg, rgba(255,255,255,.18), rgba(255,255,255,.08))' }} onClick={() => onOpen(app.id)}>
          <div style={{ fontSize: 22 }}>⚙️</div>
          <div className="app-label">{app.label}</div>
        </div>
      ))}
    </div>
  );
}

function Home({ apps, onOpen }) {
  const now = new Date();
  return (
    <div className="home">
      <StatusBar />
      <div className="center-stack" style={{ color: '#fff' }}>
        <div style={{ fontSize: 62, fontWeight: 700 }}>{now.getHours().toString().padStart(2,'0')}:{now.getMinutes().toString().padStart(2,'0')}</div>
        <div>{now.toLocaleDateString(undefined, { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}</div>
      </div>
      <div className="grid">
        {apps.filter(a => !a.dock).map(app => (
          <div key={app.id} className="app-icon" style={{ background: 'linear-gradient(145deg, rgba(255,255,255,.25), rgba(255,255,255,.12))' }} onClick={() => onOpen(app.id)}>
            <div style={{ fontSize: 22 }}>📱</div>
            <div className="app-label">{app.label}</div>
          </div>
        ))}
      </div>
      <Dock apps={apps} onOpen={onOpen} />
    </div>
  );
}

function SettingsApp({ profile, setProfile, onSave, locale }) {
  const update = (patch) => {
    const next = { ...profile, ...patch };
    setProfile(next);
    onSave(next);
  };

  return (
    <div className="settings-layout">
      <div className="settings-sidebar card">
        <div style={{ fontWeight: 700, fontSize: 18 }}>{locale.settings_title}</div>
        <div className="list-item">Appearance</div>
        <div className="list-item">Security</div>
        <div className="list-item">About</div>
      </div>
      <div className="settings-panel card">
        <div className="input-group">
          <label>{locale.settings_theme}</label>
          <select value={profile.theme} onChange={(e) => update({ theme: e.target.value })}>
            <option value="auto">Auto</option>
            <option value="light">Light</option>
            <option value="dark">Dark</option>
          </select>
        </div>
        <div className="input-group" style={{ marginTop: 12 }}>
          <label>{locale.settings_accent}</label>
          <input type="color" value={profile.accent} onChange={(e) => update({ accent: e.target.value })} />
        </div>
        <div className="input-group" style={{ marginTop: 12 }}>
          <label>{locale.settings_wallpaper}</label>
          <select value={profile.wallpaper} onChange={(e) => update({ wallpaper: e.target.value })}>
            {Object.keys(wallpapers).map(key => <option key={key} value={key}>{key}</option>)}
          </select>
        </div>
        <div className="input-group" style={{ marginTop: 12 }}>
          <label>{locale.settings_language}</label>
          <select value={profile.language} onChange={(e) => update({ language: e.target.value })}>
            <option value="de">Deutsch</option>
            <option value="en">English</option>
          </select>
        </div>
      </div>
    </div>
  );
}

function NotesApp({}) {
  const [content, setContent] = useState('');
  return (
    <div className="card" style={{ padding: 16, height: '100%' }}>
      <div style={{ fontWeight: 700, fontSize: 18, marginBottom: 10 }}>Notes</div>
      <textarea className="note-editor" placeholder="Schreib etwas ..." value={content} onChange={(e) => setContent(e.target.value)} />
    </div>
  );
}

function Onboarding({ profile, setProfile, onComplete, locale }) {
  const [step, setStep] = useState(0);
  const steps = [
    locale.onboarding_language,
    locale.onboarding_pin,
    locale.onboarding_theme,
    locale.onboarding_wallpaper,
    locale.onboarding_name
  ];

  const goNext = () => {
    if (step >= steps.length - 1) {
      onComplete();
    } else {
      setStep(step + 1);
    }
  };

  return (
    <div className="onboarding">
      <StatusBar />
      <div className="onboarding-steps">
        <div className="onboarding-left">
          <div className="card" style={{ padding: 18 }}>
            <div style={{ fontSize: 24, fontWeight: 700 }}>{locale.onboarding_title}</div>
            <div style={{ color: 'var(--muted)', marginTop: 4 }}>{steps[step]}</div>
          </div>
          <div className="card list-card">
            {steps.map((label, idx) => (
              <div key={idx} className={`list-item ${idx === step ? 'active' : ''}`} onClick={() => setStep(idx)}>
                {label}
              </div>
            ))}
          </div>
          <div style={{ display: 'flex', gap: 10 }}>
            <button className="button" onClick={() => setStep(Math.max(0, step - 1))}>Zurück</button>
            <button className="button primary" onClick={goNext}>Weiter</button>
          </div>
        </div>
        <div className="onboarding-right card">
          {step === 0 && (
            <div className="input-group">
              <label>{locale.onboarding_language}</label>
              <select value={profile.language} onChange={(e) => setProfile({ ...profile, language: e.target.value })}>
                <option value="de">Deutsch</option>
                <option value="en">English</option>
              </select>
            </div>
          )}
          {step === 1 && (
            <div className="input-group">
              <label>{locale.onboarding_pin}</label>
              <input type="password" maxLength={8} minLength={4} placeholder="1234" />
            </div>
          )}
          {step === 2 && (
            <div className="input-group">
              <label>{locale.settings_theme}</label>
              <select value={profile.theme} onChange={(e) => setProfile({ ...profile, theme: e.target.value })}>
                <option value="auto">Auto</option>
                <option value="light">Light</option>
                <option value="dark">Dark</option>
              </select>
            </div>
          )}
          {step === 3 && (
            <div className="input-group">
              <label>{locale.settings_wallpaper}</label>
              <select value={profile.wallpaper} onChange={(e) => setProfile({ ...profile, wallpaper: e.target.value })}>
                {Object.keys(wallpapers).map(key => <option key={key} value={key}>{key}</option>)}
              </select>
            </div>
          )}
          {step === 4 && (
            <div className="input-group">
              <label>{locale.onboarding_name}</label>
              <input value={profile.displayName} onChange={(e) => setProfile({ ...profile, displayName: e.target.value })} />
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

function NotificationCenter({ notifications }) {
  return (
    <div className="notification-center">
      {notifications.map((n) => (
        <div key={n.id} className="notification-card card">
          <div style={{ fontWeight: 700 }}>{n.title}</div>
          <div style={{ color: 'var(--muted)', marginTop: 4 }}>{n.message}</div>
        </div>
      ))}
    </div>
  );
}

function App() {
  const state = useNuiState();
  const [activeApp, setActiveApp] = useState('home');
  const [locale, setLocale] = useState({});

  useEffect(() => {
    fetch('https://raw.githubusercontent.com/elasticsecuritylabs/placeholder-i18n/main/tablet.json').catch(() => ({}));
  }, []);

  useEffect(() => {
    document.documentElement.dataset.theme = state.profile.theme === 'auto'
      ? (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
      : state.profile.theme;
    document.documentElement.style.setProperty('--accent', state.profile.accent);
  }, [state.profile.theme, state.profile.accent]);

  useEffect(() => {
    const url = wallpapers[state.profile.wallpaper];
    const screen = document.querySelector('.screen');
    if (screen && url) {
      screen.style.backgroundImage = `url(${url})`;
      screen.style.backgroundSize = 'cover';
      screen.style.backgroundPosition = 'center';
    }
  }, [state.profile.wallpaper]);

  const locales = {
    de: {
      ...Locales?.de,
    },
    en: {
      ...Locales?.en,
    }
  };

  useEffect(() => {
    setLocale(locales[state.profile.language] || locales.de || {});
  }, [state.profile.language]);

  const saveProfile = (profile) => {
    if (!state.deviceId) return;
    fetch('https://cfx-nui-bl_tablet/saveProfile', {
      method: 'POST',
      body: JSON.stringify({ deviceId: state.deviceId, profile })
    });
  };

  const openApp = (id) => {
    if (id === 'settings') setActiveApp('settings');
    else if (id === 'notes') setActiveApp('notes');
  };

  const showOnboarding = !state.setupDone;

  return (
    <div className="tablet-shell">
      <div className="bezel">
        <div className="screen">
          <NotificationCenter notifications={state.notifications} />
          {showOnboarding && (
            <Onboarding profile={state.profile} setProfile={state.setProfile} onComplete={() => { state.setSetupDone(true); setActiveApp('home'); saveProfile(state.profile); }} locale={locale} />
          )}
          {!showOnboarding && state.locked && (
            <Lockscreen profile={state.profile} onUnlock={(pin) => fetch('https://cfx-nui-bl_tablet/unlock', { method: 'POST', body: JSON.stringify({ deviceId: state.deviceId, pin }) })} onForgot={() => {}} />
          )}
          {!showOnboarding && !state.locked && (
            <>
              {activeApp === 'home' && <Home apps={ConfigApps} onOpen={(id) => { setActiveApp(id); if (id === 'home') state.setLocked(false); }} />}
              {activeApp === 'settings' && <SettingsApp profile={state.profile} setProfile={state.setProfile} onSave={saveProfile} locale={locale} />}
              {activeApp === 'notes' && <NotesApp />}
            </>
          )}
        </div>
      </div>
    </div>
  );
}

const ConfigApps = [
  { id: 'home', label: 'Home', dock: false },
  { id: 'settings', label: 'Settings', dock: true },
  { id: 'notes', label: 'Notes', dock: true },
  { id: 'mail', label: 'Mail', dock: true },
  { id: 'browser', label: 'Browser', dock: false },
  { id: 'gallery', label: 'Gallery', dock: false },
  { id: 'appstore', label: 'App Store', dock: false },
  { id: 'camera', label: 'Camera', dock: false }
];

const Locales = {
  de: {
    onboarding_title: 'Tablet Einrichten',
    onboarding_language: 'Sprache wählen',
    onboarding_region: 'Region & Zeitzone',
    onboarding_pin: 'PIN oder Passwort setzen',
    onboarding_biometrics: 'Biometrie (RP)',
    onboarding_theme: 'Design wählen',
    onboarding_wallpaper: 'Wallpaper wählen',
    onboarding_name: 'Name des Tablets',
    settings_title: 'Einstellungen',
    settings_theme: 'Design',
    settings_wallpaper: 'Wallpaper',
    settings_language: 'Sprache',
    settings_accent: 'Akzentfarbe'
  },
  en: {
    onboarding_title: 'Set up tablet',
    onboarding_language: 'Choose language',
    onboarding_region: 'Region & timezone',
    onboarding_pin: 'Set PIN or password',
    onboarding_biometrics: 'Biometrics (RP)',
    onboarding_theme: 'Choose theme',
    onboarding_wallpaper: 'Select wallpaper',
    onboarding_name: 'Device name',
    settings_title: 'Settings',
    settings_theme: 'Appearance',
    settings_wallpaper: 'Wallpaper',
    settings_language: 'Language',
    settings_accent: 'Accent color'
  }
};

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
