# [ZP] Math Challenge Rewards

A fun and rewarding **Zombie Plague (ZP)** mini event plugin for **Counter-Strike 1.6**, this plugin challenges all players on the server with random math problems, whoever answers correctly first earns **ammo packs** as a reward!

## Plugin Information

  - **Plugin Name** ---> [ZP] Math Challenge Rewards
  - **Version** ---> 1.0
  - **Author** ---> DadoDz
  - **Game** ---> Counter-Strike 1.6
  - **Mod** ---> Zombie Plague

## Description
This plugin automatically starts a **math challenge** every few minutes (default 150 seconds).
A random math question (addition, subtraction, multiplication, division, or factorial) is displayed on the HUD for all players.  
The first player who answers correctly in chat wins **ammo packs**, the faster they answer, the higher their reward!
If no one solves it within the given time, the plugin reveals the correct answer and starts another challenge later.

## Important: Integration with Zombie Plague

This plugin uses **custom natives** to get and set ammo packs, you must change these natives based on your zombie plague version.
  - **native zp_get_user_packs(index);**
  - **native zp_set_user_packs(index, packs);**

## Installation
1. Place 'zp_math_challenge_rewards.sma' in: addons/amxmodx/scripting/
2. Compile it with your AMXX compiler.
3. Place the compiled .amxx file in: addons/amxmodx/plugins/
4. Add this line to your plugins.ini: zp_math_challenge_rewards.amxx
5. Restart your server.

## Custom
If you want to modify timings, edit the following defines at the top of the source:
  - #define RESTART_TIME 150.0  // Time between challenges
  - #define ANSWER_TIME  20.0   // Time to answer before it expires


