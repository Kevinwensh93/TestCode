require 'minitest/autorun'
require_relative 'in_polygon_convex'

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
    assert_equal true, is_point_in_rectangle(sw_vertex, sw_vertex, ne_vertex)
    assert_equal true, is_point_in_rectangle(ne_vertex, sw_vertex, ne_vertex)
  end

  def test_is_point_in_convex_polygon
    vertices = [[0, 0], [4, 2], [8, 0], [10, 5], [6, 8], [2, 6]]
    [[5, 4], [3, 2]].each do |point|
      assert_equal true, is_point_in_convex_polygon(point, vertices)
    end

    [[100, 100], [3, 1]].each do |point|
      assert_equal false, is_point_in_convex_polygon(point, vertices)
    end

    # Edge
    [[2, 1]].each do |point|
      assert_equal true, is_point_in_convex_polygon(point, vertices)
    end

    # Vertex
    vertices.each do |point|
      assert_equal true, is_point_in_convex_polygon(point, vertices)
    end
  end
end