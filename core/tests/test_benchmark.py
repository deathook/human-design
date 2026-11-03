import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "engine"))
from datetime import datetime
from hd_calculator import calculate_chart

dt = datetime(1948, 4, 9, 0, 5)
chart = calculate_chart(dt, "America/Montreal")
d = chart.to_dict()
p_sun = d["activations"]["personality"]["Sun"]
d_sun = d["activations"]["design"]["Sun"]
print(f"Ra Uru Hu (April 9, 1948, 00:05 Montreal):")
print(f"P Sun: Gate {p_sun['gate']}.{p_sun['line']} ({p_sun['longitude']:.4f}°)")
print(f"D Sun: Gate {d_sun['gate']}.{d_sun['line']} ({d_sun['longitude']:.4f}°)")
print(f"Profile: {d['profile']['profile']}")
print(f"Type: {d['type']['name_vi']}")
print(f"Authority: {d['authority']['name_vi']}")
print(f"Channels: {[ch['id'] for ch in d['active_channels']]}")
