# Whether the dome's button controller is answering, and the last sequence the dome
# dispatched. Published on /dome/buttons/state when the controller comes or goes, when the
# dome joins the graph, and every 5 s besides, since the dome's middleware keeps no last
# value for a subscriber that starts later. A repeat carries the same `since` and `changes`.
std_msgs/Header header          # stamp: when this copy was sent, UTC
bool connected                  # the controller is answering
builtin_interfaces/Time since   # when the last report of it answering or not came; zero before the first
uint32 changes                  # those reports since boot, the first included: the same in a repeat,
                                # and a jump of two is a drop and return that went unseen
uint16 last_id                  # the last sequence dispatched (DomeButtonSequence.id); 0 for none yet
uint8  last_source              # its DomeButtonSequence.SOURCE_*
