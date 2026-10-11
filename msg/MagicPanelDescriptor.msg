# What a Magic Panel said it is, and how its controller reaches it. Interrogated off the
# device, so it changes with the panel's firmware: re-read it (ListMagicPanel) when `link`
# becomes LINK_PRESENT or `interrogations` moves on MagicPanelState.
uint8 LINK_ABSENT=0
uint8 LINK_PRESENT=1
uint8 LINK_UNSUPPORTED=2    # fitted, wired, working, and not driven: see `unsupported`

uint8 UNSUP_NONE=0
uint8 UNSUP_LEGACY=1        # v011 or older: legacy one-byte commands only, no identity. Reflash it
uint8 UNSUP_PROTO_MAJOR=2   # a protocol major this controller does not know. Update the controller
uint8 UNSUP_PROTO_V10=3     # firmware v012.0: identity IS valid, nothing else was read. One point release

uint32 NEVER=4294967295

uint8   link
uint8   unsupported

uint8   fw_major            # zero throughout under UNSUP_LEGACY: there is no identity to read
uint8   fw_minor
uint8   fw_patch
uint8   proto_major
uint8   proto_minor

uint8   seq_count           # sequences the panel reports
uint8   cached              # entries actually cached, <= 64

bool    has_legacy          # CAP_LEGACY: the panel supports one-byte commands
bool    has_repeat          # CAP_REPEAT
bool    has_brightness      # CAP_BRIGHTNESS
bool    has_names           # CAP_NAMES
bool    has_eeprom_config   # CAP_EEPROM_CONFIG
bool    has_orientation     # CAP_ORIENTATION

uint8   address             # where the controller is looking, 7-bit
uint32  scl_hz              # the per-device bus speed the controller uses
uint32  poll_period_ms
uint32  catalogue_age_ms    # since the catalogue was last read; NEVER if it never was
