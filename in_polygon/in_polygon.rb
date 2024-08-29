def is_point_in_polygon(point, vertices)
  x, y = point
  intersection_count = 0 # keep track of intersections - at the end we return true or false based on odd or even intersections

  for i in (0..vertices.length - 1) do
    second_vertex_index = i + 1 >= vertices.length ? 0 : i + 1
    vx1, vy1 = vertices[i]
    vx2, vy2 = vertices[second_vertex_index]

    # This is for inclusive point only - we can just remove the next two lines if it's not inclusive and it'll work the same
    return true if x == vx1 && y == vy1 # This is not strictly needed since the line immediately below handles it too - i.e. being on the vertex means you're also on the edge. Just a tiny optimization.
    return true if (vy2 - vy1).to_f / (vx2 - vx1).to_f  == ( y - vy1 ).to_f / ( x - vx1).to_f # Checks if point on edge. Funnily enough, this works for vertical lines as two variables assigned Float::INFINITY (result of dividing by 0 with floats) will equal each other.

    next if  vy1 == vy2 # skip horizontal line checks - horizontal ray cast will never intersect a horizontal edge
    next unless y >= [vy1, vy2].min && y <= [vy1, vy2].max && x < [vx1, vx2].max # preliminary check to see if it's possible to intersect

    x_intersection = (y - vy1).to_f * (vx2 - vx1) / (vy2 - vy1) + vx1 # finds full horizontal line intersection x value
    intersection_count += 1 if x < x_intersection # checks previous x value against the point's x coordinate to see if the ray we cast to the right intersects it (to the right).
  end

  return intersection_count.odd?
end