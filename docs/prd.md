# 🎮 BounceTap – Ultra Simple Game Plan (Core Only)

## 1️⃣ Game Concept

**BounceTap**
Player taps the screen to make a ball bounce upward.
If the ball touches the bottom of the screen → Game Over.

That’s it.

---

# 🎯 2️⃣ Core Gameplay Loop

1. Game starts
2. Ball falls due to gravity
3. Player taps → Ball gets upward force
4. Player keeps tapping to prevent falling
5. If ball hits bottom → Show score → Restart option

Simple endless survival game.

---

# 🧠 3️⃣ Core Mechanics (Only What’s Needed)

### Ball Physics

* Gravity pulls ball down constantly
* On tap → Apply fixed upward force
* No horizontal movement
* No obstacles
* No powerups

### Score

* Score increases over time (1 point per second)
  OR
* Score increases per successful tap

(Choose one. Time-based is simpler.)

### Game Over Condition

* Ball Y position <= bottom boundary

---

# 🖥 4️⃣ Screens (Minimum)

## A. Game Screen

* Ball
* Score text (top center)

## B. Game Over Overlay

* Final Score
* "Restart" button

No main menu.
Game starts immediately on launch.

---

# 🧱 5️⃣ Core Components Structure

### GameManager

* StartGame()
* EndGame()
* RestartGame()
* Track score

### BallController

* Apply gravity
* Apply bounce force on tap
* Detect ground collision

### UIManager

* Update score text
* Show/hide Game Over screen

---

# ⚙️ 6️⃣ Basic Variables

```
gravity = -9.8
bounceForce = 15
score = 0
isGameOver = false
```

Keep numbers adjustable in inspector.

---

# 🚀 7️⃣ Development Steps (Fast Order)

### Step 1

Create scene
Add:

* Background color
* Ball object
* Bottom boundary (invisible collider)

### Step 2

Add gravity to ball

### Step 3

Detect screen tap → Apply upward force

### Step 4

Add score system (time-based)

### Step 5

Detect collision with bottom → End game

### Step 6

Add simple Game Over UI

Done.

---

# 🎨 8️⃣ Visual Style (Keep Simple)

* Solid background color
* White ball
* Basic font
* No animations
* No sound (for now)

---

# ⏱ Estimated Build Time

If using Unity / Godot / Flutter Flame:
**3–6 hours** for MVP.