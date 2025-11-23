class_name Globals extends Node

static var total_bugs := 1
static var killed_bugs := 0

static var total_glitches := 0
static var removed_glitches := 0

static var player: Player

static func bug_killed():
	killed_bugs += 1

static func removed_glitch():
	removed_glitches += 1
