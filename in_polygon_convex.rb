def is_point_in_rectangle(point, vertex1, vertex2) # rectangle whose edges are parallel to x/y axes
  x, y = point
  x1, y1 = vertex1
  x2, y2 = vertex2

  xmax = [x1, x2].max
  xmin = [x1, x2].min
  return false if x < xmin || x > xmax # edge-inclusive; >= and <= on false and strict for true for non-edge inclusive
  # early return if it exceeds x bounds. no need to run rest of method. small optimization

  ymax = [y1, y2].max
  ymin = [y1, y2].min
  return false if y < ymin || y > ymax

  return true # if satisfies both conditions return true (default)
end

# input is array of tuple arrays - we are assuming consistentclockwise/counterclockwise order.
def is_point_in_convex_polygon(point, vertices)
  x, y = point

  # Checking if bounding rectangle with parallel edges to x/y axes contains point. If not, return false (it cannot be in the inner polygon)
  xmin, ymin = vertices[0]
  xmax, ymax = vertices[0]

  vertices.each do |x, y|
    xmin = [xmin, x].min
    xmax = [xmax, x].max
    ymin = [ymin, y].min
    ymax = [ymax, y].max
  end

  return false if  x < xmin || x > xmax || y < ymin || y > ymax

  for i in (0..vertices.length - 1) do # It should check the last vertex to the first vertex as well.
    second_vertex_index = i + 1 >= vertices.length ? 0 : i + 1
    in_small_rectangle = is_point_in_rectangle(point, vertices[i], vertices[second_vertex_index])
    if in_small_rectangle
      vx1, vy1 = vertices[i]
      vx2, vy2 = vertices[second_vertex_index]
      
      # For a convex polygon we expect delta-y over delta-x for the point to the be greater than for vertex to the next adjacent vertex
      # Although this check runs inside a loop, it is only run once. the in_small_rectangle condition can only be satisfied for one set of vertices
      vertex_to_vertex_slope = (vy2 - vy1).to_f.abs / (vx2 - vx1).to_f.abs # btw, ruby allows divide by zero. It turns into Float::INFINITY and can be used in comparisons - for another language we'd need an if statement to take care of this
      vertex_to_point_slope = (y - vy1).to_f.abs / (x - vx1).to_f.abs
      # puts "#{vertex_to_vertex_slope} and #{vertex_to_point_slope}"
      if vertex_to_point_slope < vertex_to_vertex_slope # <= if non-edge-inclusive
        return false
      end
      # We do not need to check purely vertical/horizontal edges as this'll have been taken care of via the is_small_rectangle flag. if the point is in the mini-rectangle with 0 height or width it's on the edge itself.
      # For non-edge inclusive implementation we WOULD want to check if it is vertical or horizontal and return false if it's captured by the mini-rectangle...

    end
  end

  return true # Passing the bounding rectangle check and not being in any of the rectangles created by adjacent vertices means it's inside the polygon
end