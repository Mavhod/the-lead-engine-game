# Game Design Document: The Lead Engine

## 1. Project Overview
* **Name:** The Lead Engine
* **Genre:** Management RPG / Leadership Simulation
* **Platform:** Godot 4 (PC)
* **Goal:** Manage 4 employees to handle incoming tasks, develop team skills, and maintain organizational Trust above 0.

---

## 🎮 Controls & Interaction
- **Assign Staff:** Click and drag a staff member's card and drop it onto an active task card.
- **Remove Staff:** Click the **(-)** button on a staff member within a task card to unassign them.
- **Level Up:** When a member earns enough EXP, a level-up indicator will appear. Use the **Member Stats UI** to allocate attribute points.

---

## 2. Staff System
A team of 4 employees with different initial specializations. They can level up to improve their skills.

### A. Member Stats
1. **Core Skills:** (Affects work speed for each task type)
   * **Technical:** System/programming tasks
   * **Admin:** Documentation/management tasks
   * **Creative:** Creative/design tasks
2. **Base Attributes:**
   * **Stamina:** Energy level
     * Decreases while working / Increases when idle (IDLE)
   * **Speed:** Work speed
   * **Learning Rate:** Skills increase based on the task type during work. A higher learning rate speeds up this progression.
   * **Multitask Skill:** When working on more than 1 task, performance decreases (if negative) or increases (if positive).
   * **Teamwork Skill:** When working on a task with teammates, performance decreases (if negative) or increases (if positive).

### B. Progression
* **EXP:** Experience points earned through working.
* **Level Up:** When reaching the EXP threshold, players receive points for Manual Stat Distribution.

---

## 3. Task System
Tasks flow from right to left with time and personnel constraints.

### A. Task Properties
* **Type:** (Technical, Admin, Creative)
* **Deadline:** Countdown timer
* **Progress:** Work completion percentage (0-100%)
* **Scalability Factor:** (0.5 - 1.0) 
  * Determines how efficiently a task can be tackled by multiple people (The Mythical Man-Month Logic).
  * If Scalability is low, the 2nd to 4th staff members added to the task will contribute very little speed boost.

### B. Trust
* **Trust Impact:** If a task is not 100% complete when the time expires, it is considered "burned work," reducing Trust proportionally based on the remaining workload.
* **Game Over:** When Trust reaches 0.

---

## 4. Core Gameplay Mechanics
1. **Drag & Drop:** Drag staff onto a Task to start working. Press the (-) button on a staff member to remove them from a task.
2. **Resource Allocation:** Decide whether to add more people if a task might not finish on time, or remove someone when their Stamina is low, etc.
3. **Growth Strategy:** Upgrade staff attributes after they Level up.

---

## 💻 Technical Details
- **Engine:** Godot 4
- **Language:** GDScript
- **Architecture:** 
  - **Component-based UI:** Modular scenes for Task Cards, Staff Members, and Stats.
  - **Resource-driven Data:** Uses Godot `Resource` scripts (`member.gd`, `task.gd`) for flexible character and mission management.
  - **Signal-based Interaction:** Decoupled communication between the game engine and UI components.

## 📂 Project Structure
- `src/ui/`: Contains all UI scenes and scripts (HUD, Task Cards, Stats).
- `src/resources/`: Contains data definitions for members and tasks.
- `src/utils/`: General-purpose helper scripts and mathematical functions.

---
