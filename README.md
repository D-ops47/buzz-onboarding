# Buzz Onboarding — Set up like the rest of the team

Welcome to **BlackGuard** — our team's Buzz workspace. Buzz is the app we use to
work together and where our AI agents (Fable, Codex, Gemini, Grok) live and get
things done. This guide walks you through everything you need so you end up with
the exact same setup the rest of us have.

> ⏱ Time: ~15 minutes on the first pass.

---

## Step 1 — Install the Buzz app

Download the desktop app. Choose the build that matches your Mac's chip:

- **Apple Silicon (M1/M2/M3/M4)** → the `aarch64` (.dmg) build
- **Intel Mac** → the `x64` (.dmg) build

1. Open the releases page: **https://github.com/block/buzz/releases**
2. Grab the newest release's `.dmg` for your chip and install it.
3. If you don't know your chip: click the  in the top-left of your Mac → **About This Mac** → it says "Apple" for Silicon, or "Intel" for Intel.

> Optional but handy: check your chip in the terminal with `uname -m`
> (`arm64` = Apple Silicon, `x86_64` = Intel).

Open the app once after installing.

---

## Step 2 — Create your identity (this is your login)

Buzz has **no passwords**. Your identity is a cryptographic key that the app
creates for you on your first launch. It's yours and only yours.

- On first launch, Buzz generates your identity automatically.
- **Back it up right away** — there is no "forgot password" and no account
  recovery on Buzz. If you lose your key, you lose your identity and no one can
  get it back. Save the backup your app shows you into your password manager
  (1Password / LastPass / Apple Passwords) and store a copy somewhere safe.
- **Find your public key** — this is the shareable part of your identity. In the
  app, go to your profile and copy your public key (looks like a long string of
  letters and numbers).
- **Send your public key to the admin** so they can add you to the **BlackGuard**
  community. You're not fully in until that's done.

> Think of it like this: your private key = your keys to the car (never share).
> Your public key = your license plate (fine to share, it's how people find you).

---

## Step 3 — Wire in the AI agents (the part everyone forgets)

What makes our workspace tick is that we can call in AI agents from inside Buzz.
To run them on **your** machine, install the tools and sign in with the
**org-provided account**. You do **not** need your own subscription, and you will
never pay for any of this — the company covers it.

> **Before Step 3:** message the admin and ask for your **Claude** and **Codex**
> sign-in access. They'll provision it for you. You'll use that org-provided
> login below — never a personal account.

### 3a — Claude Code (runs Fable + the Claude-based agents)

1. Open Terminal and run:

   ```bash
   curl -fsSL https://claude.ai/install.sh | bash
   ```

2. Verify it installed:

   ```bash
   claude --version
   ```

3. Sign in with your **org-provided** Claude access (the first `claude` command
   opens a browser to log in — use the account the admin set up for you):

   ```bash
   claude
   ```

### 3b — Codex (runs the Codex agent)

1. Open Terminal and install (needs Node.js 18+; if you don't have it, grab it
   from https://nodejs.org first):

   ```bash
   curl -fsSL https://chatgpt.com/codex/install.sh | sh
   ```
   or, via npm:
   ```bash
   npm install -g @openai/codex
   ```

2. Verify:

   ```bash
   codex --version
   ```

3. Sign in with your **org-provided** OpenAI/Codex access from the admin:

   ```bash
   codex login
   ```

### 3c — Gemini & Grok (optional but we run these too)

These route through a separate bridge on our side; the built-in welcome agents
(Fizz, Honey, Bumble) work out of the box with no extra setup. If you run into
any snag getting Gemini or Grok wired, ping the admin — one of us will help you
finish that piece.

---

## Step 4 — Confirm it's all hooked up

1. Restart Buzz after you've installed and signed into the tools above.
2. You should see the **BlackGuard** community and its channels (Welcome,
   general, welcome-everyone, etc.).
3. In the agents area, you should see the same personas the rest of us have —
   **Fable**, **Codex**, **Gemini**, **Grok**, and the **Welcome Team**
   (Fizz, Honey, Bumble). If any are missing or show as disconnected, let the
   admin know.

---

## A few important notes

- **Your access is provided by the org.** You never pay for any of these tools.
  If anything ever asks you for payment or a personal login, stop and check with
  the admin — that's not the setup.
- **Your machine needs to be on** for your agents to run. Buzz spawns agents
  locally on your computer using your signed-in accounts, so if your laptop is
  closed, your agents are offline. That's normal.
- **Don't hand your credentials to an agent.** A specialized agent should only
  be given access to what it needs for the task at hand — never your passwords
  or API keys. Each agent runs under a narrow authorization you grant it.
- **Community messages** on Block's default relay aren't end-to-end encrypted.
  Avoid putting anything truly sensitive (passwords, bank details) in channel
  messages. For anything sensitive, use a DM or keep it out of Buzz.
- **Built-in vs custom agents:** the welcome trio (Fizz, Honey, Bumble) come with
  Buzz for free. Fable, Codex, Gemini, and Grok are the power-user personas we
  run for real work.

---

*Something not working?* Ask in the `general` channel or DM the admin. Get your
public key to the admin as soon as you finish Step 2 so your access lands and
you can start using the workspace.
