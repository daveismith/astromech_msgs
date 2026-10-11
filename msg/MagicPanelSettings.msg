# A Magic Panel's own settings: live, or as its EEPROM holds them.
uint8   brightness          # live, 0..15; 0 is dim, NOT off
uint8   default_brightness  # loaded at power-on; changes nothing now
bool    rotated             # ORIENT_ROTATE_180
bool    legacy              # CFG_LEGACY: the panel answers one-byte commands
bool    inputs              # CFG_GPIO_ENABLE: its rotary switch and jumpers are live
bool    resume              # CFG_GPIO_RESUME: a GPIO mode restarts after an I2C sequence ends
