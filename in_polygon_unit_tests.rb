require 'minitest/autorun'
require_relative 'in_polygon_convex'
require_relative 'in_polygon'

class TestMethods < Minitest::Test
  def test_point_in_rectangle
    sw_vertex = [0, 0]
    ne_vertex = [10, 10]

    # outside
    [[1, 1], [5, 5], [9, 9], [4, 6]].each do |point|
      assert_equal true, is_point_in_rectangle(point, sw_vertex, ne_vertex)
    end

    # inside
    [[11, 1], [1, 11], [-1, 1], [1, -1]].each do |point|
      assert_equal false, is_point_in_rectangle(point, sw_vertex, ne_vertex)
    end

    # point on edge. a real "edge" case
    assert_equal true, is_point_in_rectangle([0, 5], sw_vertex, ne_vertex)

    # point on vertex
    [sw_vertex, ne_vertex].each do |point|
      assert_equal true, is_point_in_rectangle(point, sw_vertex, ne_vertex)
    end
  end

  def test_is_point_in_convex_polygon
    vertices = [[0, 0], [4, 2], [8, 0], [10, 5], [6, 8], [2, 6]]

    # Inside
    [[5, 4], [3, 2]].each do |point|
      assert_equal true, is_point_in_convex_polygon(point, vertices)
    end

    # Outside
    [[100, 100], [3, 1]].each do |point|
      assert_equal false, is_point_in_convex_polygon(point, vertices)
    end

    # Edge
    # puts "#{generate_midpoints(vertices)}"
    midpoints = generate_midpoints(vertices)
    midpoints.each do |point|
      assert_equal true, is_point_in_convex_polygon(point, vertices)
    end

    # Vertex - we can just loop through all vertices
    vertices.each do |point|
      assert_equal true, is_point_in_convex_polygon(point, vertices)
    end
  end

  def test_is_point_in_polygon
    vertices_concave = [[0, 0], [4, 2], [2, 2], [2, 8], [8, 0], [10, 10], [0, 10]]
    vertices_convex = [[0, 0], [4, 2], [8, 0], [10, 5], [6, 8], [2, 6]]

    [vertices_concave, vertices_convex].each do |vertices|
      # Inside
      [[1, 1]].each do |point|
        assert_equal true, is_point_in_polygon(point, vertices)
      end

      # Outside
      [[100, 100], [3, 1]].each do |point|
        assert_equal false, is_point_in_polygon(point, vertices)
      end

      # Edge
      # puts "#{generate_midpoints(vertices)}"
      midpoints = generate_midpoints(vertices)
      midpoints.each do |point|
        assert_equal true, is_point_in_polygon(point, vertices)
      end

      # Vertex - we can just loop through all vertices
      vertices.each do |point|
        assert_equal true, is_point_in_polygon(point, vertices)
      end
    end
  end
end

# Generating a list of midpoints between each edge to test points on edges
def generate_midpoints(vertices)
  midpoints = []

  for i in (0..vertices.length - 1) do
    second_vertex_index = i + 1 >= vertices.length ? 0 : i + 1
    vx1, vy1 = vertices[i]
    vx2, vy2 = vertices[second_vertex_index]
    midpoint = [(vx1 + vx2) / 2.0, (vy1 + vy2) / 2.0]
    midpoints.push(midpoint)
  end

  return midpoints
end