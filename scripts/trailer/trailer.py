# Trailer "Die Fahrt zum Kunden" (Hero, stumm, Schleife).
# Aufruf: blender -b -P trailer.py -- --out <pfad> [--stills 1,200,470] [--res 1080] [--samples 16]
import argparse
import math
import random
import sys

import bpy

argv = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
ap = argparse.ArgumentParser()
ap.add_argument("--out", required=True)
ap.add_argument("--stills", default="")
ap.add_argument("--res", type=int, default=1080)
ap.add_argument("--samples", type=int, default=16)
args = ap.parse_args(argv)

FPS, END = 24, 480
STEP = 2

bpy.ops.wm.read_factory_settings(use_empty=True)
scene = bpy.context.scene
try:
    bpy.context.preferences.edit.keyframe_new_interpolation_type = 'LINEAR'
except Exception as e:
    print("WARN interpolation", e)


def lin(c):
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4


def rgb(hexstr):
    h = hexstr.lstrip('#')
    return tuple(lin(int(h[i:i + 2], 16) / 255) for i in (0, 2, 4)) + (1.0,)


def mix(a, b, t):
    return tuple(a[i] + (b[i] - a[i]) * t for i in range(4))


def smooth(t):
    t = max(0.0, min(1.0, t))
    return t * t * (3 - 2 * t)


def material(name, hexcol, emit=0.0, rough=0.9):
    m = bpy.data.materials.new(name)
    try:
        m.use_nodes = True
    except Exception:
        pass
    b = m.node_tree.nodes.get("Principled BSDF")
    b.inputs["Base Color"].default_value = rgb(hexcol)
    b.inputs["Roughness"].default_value = rough
    if emit:
        b.inputs["Emission Color"].default_value = rgb(hexcol)
        b.inputs["Emission Strength"].default_value = emit
    return m


def add(kind, name, mat, loc=(0, 0, 0), scale=(1, 1, 1), rot=(0, 0, 0), parent=None, smooth_shade=False, **kw):
    getattr(bpy.ops.mesh, "primitive_" + kind + "_add")(location=loc, rotation=rot, **kw)
    o = bpy.context.active_object
    o.name = name
    o.scale = scale
    o.data.materials.append(mat)
    if smooth_shade:
        for p in o.data.polygons:
            p.use_smooth = True
    if parent:
        o.parent = parent
    return o


def empty(name, loc=(0, 0, 0), parent=None):
    o = bpy.data.objects.new(name, None)
    o.location = loc
    scene.collection.objects.link(o)
    if parent:
        o.parent = parent
    return o


def light(name, kind, energy, hexcol, loc=(0, 0, 0), rot=(0, 0, 0), parent=None):
    d = bpy.data.lights.new(name, kind)
    d.energy = energy
    d.color = rgb(hexcol)[:3]
    o = bpy.data.objects.new(name, d)
    o.location = loc
    o.rotation_euler = rot
    scene.collection.objects.link(o)
    if parent:
        o.parent = parent
    return o


# ---------- Materialien (Farben der Webseite) ----------
M_GROUND = material("Boden", "#17485c")
M_HILL = material("Huegel", "#0f3445")
M_ROAD = material("Strasse", "#0c2531")
M_DASH = material("Mittellinie", "#edf2f4", emit=0.6)
M_TREE = material("Baum", "#1d5a5e")
M_CAR = material("Auto", "#dfe6ea", rough=0.5)
M_CABIN = material("Kabine", "#14202a", rough=0.3)
M_WHEEL = material("Rad", "#0a1218")
M_HEAD = material("Scheinwerfer", "#fff3d6", emit=12)
M_TAIL = material("Ruecklicht", "#ff4a3a", emit=6)
M_MOON = material("Mond", "#f3efe6", emit=2.2)
M_STAR = material("Stern", "#edf2f4", emit=3)
M_NAVIS = material("Navis", "#55d6c2", emit=3.5)
M_LUMEN = material("Lumen", "#f1b854", emit=3.5)
M_HOUSE = material("Haus", "#f3efe6")
M_ROOF = material("Dach", "#9a5a44")
M_WINDOW = material("Fenster", "#ffc76a", emit=9)
M_DOOR = material("Tuer", "#1b4f66")

# ---------- Landschaft ----------
random.seed(7)
add("plane", "Boden", M_GROUND, loc=(0, 300, 0), size=3000)
add("plane", "Strasse", M_ROAD, loc=(0, 300, 0.02), scale=(3.5, 700, 1), size=2)
for i in range(-10, 130):
    add("cube", "Linie", M_DASH, loc=(0, i * 6, 0.03), scale=(0.07, 1.2, 0.01), size=2)
for i in range(46):
    side = random.choice((-1, 1))
    add("ico_sphere", "Huegel", M_HILL,
        loc=(side * random.uniform(125, 320), random.uniform(-60, 900), -4),
        scale=(random.uniform(40, 90), random.uniform(40, 90), random.uniform(10, 30)),
        subdivisions=3, smooth_shade=True)
for i in range(150):
    side = random.choice((-1, 1))
    y = random.uniform(-40, 520)
    x = side * random.uniform(7, 45)
    if 290 < y < 335 and x > 0:
        continue  # Platz fuer das Haus
    h = random.uniform(2.5, 6)
    add("cone", "Baum", M_TREE, loc=(x, y, h / 2), scale=(h * 0.3, h * 0.3, h / 2),
        vertices=7, radius1=1, depth=2)

# ---------- Haus am Ziel ----------
HX, HY = 11, 312
add("cube", "Haus", M_HOUSE, loc=(HX, HY, 2.2), scale=(4, 3.5, 2.2), size=2)
add("cone", "Dach", M_ROOF, loc=(HX, HY, 5.6), scale=(5.6, 5.0, 1.3), rot=(0, 0, math.radians(45)),
    vertices=4, radius1=1, depth=2)
add("cube", "FensterL", M_WINDOW, loc=(HX - 4.02, HY - 1.6, 2.6), scale=(0.05, 0.8, 0.8), size=2)
add("cube", "FensterR", M_WINDOW, loc=(HX - 4.02, HY + 1.6, 2.6), scale=(0.05, 0.8, 0.8), size=2)
add("cube", "FensterS", M_WINDOW, loc=(HX - 1.5, HY - 3.52, 2.6), scale=(0.8, 0.05, 0.8), size=2)
add("cube", "Tuer", M_DOOR, loc=(HX + 1.6, HY - 3.52, 1.3), scale=(0.7, 0.05, 1.3), size=2)
add("cube", "Weg", M_ROAD, loc=(HX / 2 + 1, HY - 9, 0.02), scale=(HX / 2 + 1, 1.6, 0.01), size=2)
light("Hauslicht", 'POINT', 700, "#ffc76a", loc=(HX - 6.5, HY - 4, 3))
light("Hauslicht2", 'POINT', 500, "#ffc76a", loc=(HX - 1, HY - 7, 2.5))

# ---------- Auto, Kamera, Himmel (alles am Rig) ----------
rig = empty("Rig")
add("cube", "Karosserie", M_CAR, loc=(0, 0, 0.75), scale=(0.95, 2.2, 0.42), size=2, parent=rig)
add("cube", "Kabine", M_CABIN, loc=(0, -0.3, 1.45), scale=(0.82, 1.15, 0.36), size=2, parent=rig)
for sx in (-0.95, 0.95):
    for sy in (-1.4, 1.4):
        add("cylinder", "Rad", M_WHEEL, loc=(sx, sy, 0.38), rot=(0, math.radians(90), 0),
            scale=(0.38, 0.38, 0.14), radius=1, depth=2, vertices=16, parent=rig)
    add("cube", "Scheinwerfer", M_HEAD, loc=(sx * 0.68, 2.21, 0.8), scale=(0.2, 0.03, 0.1), size=2, parent=rig)
    add("cube", "Ruecklicht", M_TAIL, loc=(sx * 0.68, -2.21, 0.85), scale=(0.2, 0.03, 0.08), size=2, parent=rig)
    sp = light("Lichtkegel", 'SPOT', 9000, "#fff0cf", loc=(sx * 0.68, 2.3, 0.85),
               rot=(math.radians(84), 0, 0), parent=rig)
    sp.data.spot_size = math.radians(60)
    sp.data.spot_blend = 0.6

add("ico_sphere", "Mond", M_MOON, loc=(110, 520, 190), scale=(22, 22, 22), subdivisions=4,
    smooth_shade=True, parent=rig)
for i in range(90):
    add("ico_sphere", "Stern", M_STAR,
        loc=(random.uniform(-600, 600), random.uniform(500, 800), random.uniform(60, 520)),
        scale=(1.1, 1.1, 1.1), subdivisions=1, parent=rig)

cam_d = bpy.data.cameras.new("Kamera")
cam_d.lens = 32
cam_d.clip_start = 0.1
cam_d.clip_end = 3000
cam = bpy.data.objects.new("Kamera", cam_d)
scene.collection.objects.link(cam)
cam.parent = rig
scene.camera = cam
target = empty("Ziel", parent=rig)
tr = cam.constraints.new('TRACK_TO')
tr.target = target
tr.track_axis = 'TRACK_NEGATIVE_Z'
tr.up_axis = 'UP_Y'

navis = add("ico_sphere", "Navis", M_NAVIS, subdivisions=3, smooth_shade=True, parent=rig)
lumen = add("ico_sphere", "Lumen", M_LUMEN, subdivisions=3, smooth_shade=True, parent=rig)
light("NavisLicht", 'POINT', 500, "#55d6c2", parent=navis)
light("LumenLicht", 'POINT', 500, "#f1b854", parent=lumen)

moonlight = light("Mondlicht", 'SUN', 0.5, "#9fc4d6", rot=(math.radians(35), 0, math.radians(-30)))
sun = light("Morgenlicht", 'SUN', 0.0, "#ffcf8a", rot=(math.radians(-78), 0, math.radians(-25)))

# ---------- Himmel mit Verlauf ----------
world = bpy.data.worlds.new("Himmel")
scene.world = world
try:
    world.use_nodes = True
except Exception:
    pass
wn, wl = world.node_tree.nodes, world.node_tree.links
bg = wn.get("Background") or wn.new("ShaderNodeBackground")
wout = wn.get("World Output") or wn.new("ShaderNodeOutputWorld")
tc = wn.new("ShaderNodeTexCoord")
sep = wn.new("ShaderNodeSeparateXYZ")
ramp = wn.new("ShaderNodeValToRGB")
wl.new(tc.outputs["Generated"], sep.inputs[0])
wl.new(sep.outputs["Z"], ramp.inputs[0])
wl.new(ramp.outputs["Color"], bg.inputs["Color"])
wl.new(bg.outputs["Background"], wout.inputs["Surface"])
ramp.color_ramp.elements[0].position = 0.0
ramp.color_ramp.elements[1].position = 0.45
SKY_H_NIGHT, SKY_Z_NIGHT = rgb("#1f566d"), rgb("#081c28")
SKY_H_DAWN, SKY_Z_DAWN = rgb("#f6b860"), rgb("#2f627a")

# ---------- Blende fuer die Schleife ----------
fade_m = bpy.data.materials.new("Blende")
try:
    fade_m.use_nodes = True
except Exception:
    pass
fn, fl = fade_m.node_tree.nodes, fade_m.node_tree.links
fn.clear()
f_out = fn.new("ShaderNodeOutputMaterial")
f_mix = fn.new("ShaderNodeMixShader")
f_tr = fn.new("ShaderNodeBsdfTransparent")
f_em = fn.new("ShaderNodeEmission")
f_em.inputs["Color"].default_value = rgb("#0d2c3b")
fl.new(f_tr.outputs[0], f_mix.inputs[1])
fl.new(f_em.outputs[0], f_mix.inputs[2])
fl.new(f_mix.outputs[0], f_out.inputs["Surface"])
for attr, val in (("surface_render_method", 'BLENDED'), ("blend_method", 'BLEND')):
    try:
        setattr(fade_m, attr, val)
    except Exception as e:
        print("WARN", attr, e)
fade = add("plane", "Blende", fade_m, loc=(0, 0, -0.3), size=1, parent=cam)
try:
    fade.visible_shadow = False
except Exception:
    pass


# ---------- Bewegung ----------
def car_y(f):
    if f <= 340:
        return 0.767 * (f - 1)
    t = min(1.0, (f - 340) / 100)
    return 260 + 40 * (1 - (1 - t) ** 2)


def key(obj, path, frame):
    obj.keyframe_insert(path, frame=frame)


frames = list(range(1, END + 1, STEP))
if frames[-1] != END:
    frames.append(END)

for f in frames:
    t = (f - 1) / (END - 1)
    rig.location = (1.7, car_y(f), 0)
    key(rig, "location", f)

    # Kamera: ruhiger Schwenk von links hinten nach rechts hinten, am Ende hoeher
    s = smooth(t)
    cam.location = (-5.5 + 9.0 * s, -11.5 - 2.5 * s, 3.6 + 2.6 * s)
    key(cam, "location", f)
    target.location = (1.5 * s, 9 + 4 * s, 1.2 + 0.8 * s)
    key(target, "location", f)

    # Navis und Lumen kommen ab Sekunde 5 dazu und begleiten das Auto
    a = smooth((f - 120) / 70)
    bob = math.sin(f / 9.0)
    bob2 = math.sin(f / 11.0 + 1.3)
    navis.location = (-22 + (22 - 2.6) * a + 0.25 * bob2, 60 - (60 - 5.5) * a, 26 - (26 - 2.0) * a + 0.3 * bob)
    lumen.location = (24 - (24 - 2.8) * a + 0.25 * bob, 70 - (70 - 3.8) * a, 30 - (30 - 2.6) * a + 0.3 * bob2)
    sc = 0.42 * smooth((f - 115) / 30)
    navis.scale = lumen.scale = (sc, sc, sc)
    for o in (navis, lumen):
        key(o, "location", f)
        key(o, "scale", f)

    # Morgen: Himmel und Sonne ab Sekunde 11
    d = smooth((f - 260) / 170)
    e0, e1 = ramp.color_ramp.elements[0], ramp.color_ramp.elements[1]
    e0.color = mix(SKY_H_NIGHT, SKY_H_DAWN, d)
    e1.color = mix(SKY_Z_NIGHT, SKY_Z_DAWN, d)
    e0.keyframe_insert("color", frame=f)
    e1.keyframe_insert("color", frame=f)
    sun.data.energy = 2.2 * d
    sun.data.keyframe_insert("energy", frame=f)

    # Blende: weich aus der Nacht heraus und am Ende zurueck
    fac = max(1 - (f - 1) / 14, smooth((f - (END - 34)) / 30), 0.0)
    f_mix.inputs[0].default_value = fac
    f_mix.inputs[0].keyframe_insert("default_value", frame=f)

# ---------- Rendern ----------
r = scene.render
for eng in ('BLENDER_EEVEE', 'BLENDER_EEVEE_NEXT'):
    try:
        r.engine = eng
        break
    except Exception:
        continue
print("ENGINE", r.engine)
try:
    scene.eevee.taa_render_samples = args.samples
except Exception as e:
    print("WARN samples", e)
try:
    scene.view_settings.view_transform = 'Standard'
except Exception as e:
    print("WARN view", e)
r.resolution_x = r.resolution_y = args.res
r.resolution_percentage = 100
r.fps = FPS
scene.frame_start, scene.frame_end = 1, END

if args.stills:
    r.image_settings.file_format = 'PNG'
    for f in [int(x) for x in args.stills.split(",")]:
        scene.frame_set(f)
        r.filepath = f"{args.out}_{f:04d}.png"
        bpy.ops.render.render(write_still=True)
else:
    try:
        r.image_settings.media_type = 'VIDEO'
    except Exception as e:
        print("WARN media_type", e)
    r.image_settings.file_format = 'FFMPEG'
    r.ffmpeg.format = 'MPEG4'
    r.ffmpeg.codec = 'H264'
    r.ffmpeg.constant_rate_factor = 'MEDIUM'
    r.ffmpeg.ffmpeg_preset = 'GOOD'
    r.ffmpeg.gopsize = FPS
    r.ffmpeg.audio_codec = 'NONE'
    r.filepath = args.out
    bpy.ops.render.render(animation=True)
print("FERTIG")
