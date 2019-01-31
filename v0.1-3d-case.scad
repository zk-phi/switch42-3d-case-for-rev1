$unit = 19.05;
$100mil = 2.54;
$pcb_grid = 0.297658;
$wall_thickness = 2;
$support_thickness = 3.0;
$wall_height = 1.6 + 1.5;
$floor_thickness = 1.7;
$cover_thickness = 1.5;
$bottom_height = 6 + $cover_thickness;

$slop = 1;
$promicro_width  = 7 * $100mil + $slop;
$promicro_height = 2.5 + $slop / 2;
$trrs_width = 6 + $slop;
$trrs_height = 5 + $slop / 2;

module shape (extra_thickness = 0, height = 0, offset1 = 0, offset2 = 0) {
  translate([- extra_thickness, $unit - extra_thickness + offset2, 0])
    cube([6 * $unit + extra_thickness * 2, 3 * $unit + extra_thickness * 2 - offset2, height]);
  translate([- extra_thickness, - extra_thickness, 0])
    cube([3 * $unit + extra_thickness * 2 - offset1, 20, height]);
}

// case without promicro and trrs holes
module model1 (mirror = 0) {
  translate([3 * $unit ,0 ,0]) mirror([mirror, 0, 0]) translate([- 3 * $unit, 0, 0]) difference () {
    shape($wall_thickness, $bottom_height + $wall_height);
    translate([0, 0, $bottom_height]) shape(0, 1000, $pcb_grid * 2, $pcb_grid);
    translate([0, 0, $cover_thickness]) shape(-$floor_thickness, 1000, $pcb_grid * 2, $pcb_grid);
  }
}

// model1 with promicro and trrs holes
module model2 (mirror = 0) {
  difference () {
    model1(mirror);
    // promicro
    translate([2.5 * $unit - $promicro_width / 2, 4 * $unit - $floor_thickness, $bottom_height - $promicro_height])
      cube([$promicro_width, 1000, 1000]);
    // trrs
    translate([4 * $unit - $trrs_width / 2, 4 * $unit - $floor_thickness, $bottom_height - $trrs_height])
      cube([$trrs_width, 1000, 1000]);
  }
}

// model2 with supports
module model3 (mirror = 0) {
  model2(mirror);
  translate([0, 1 * $unit - $support_thickness / 2, 0])
    cube([$wall_thickness + 6 * $unit, $support_thickness, $bottom_height]);
  translate([0, 2 * $unit - $support_thickness / 2, 0])
    cube([$wall_thickness + 6 * $unit, $support_thickness, $bottom_height]);
  translate([0, 3 * $unit - $support_thickness / 2, 0]) {
    cube([$wall_thickness + 1.5 * $unit, $support_thickness, $bottom_height]);
    translate([3.5 * $unit, 0, 0])
      cube([2.5 * $unit, $support_thickness, $bottom_height]);
  }
}

module pcb_preview_kicad (left = false) {
  translate([9.5, 47.5, 1.6]) import("../pcb/switch42.stl");
}

translate([6 * $unit + $wall_thickness * 2 + $slop, 0, 0]) model3();
model3(1);
//translate([6 * $unit + $wall_thickness * 2 + $slop, 4 * $unit + $wall_thickness * 2 + $slop, 0]) model3(0);
//translate([0, 4 * $unit + $wall_thickness * 2 + $slop, 0]) model3(1);
//transalte([0, 10 * $unit, 0]) {
//  translate([6 * $unit + $wall_thickness * 2 + $slop, 0, 0]) model3();
//  model3(1);
//}
//color([1, 1, 1, 0.1]) translate([0, $unit, $bottom_height]) pcb_preview_kicad();