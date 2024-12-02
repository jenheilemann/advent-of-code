# --- Day 22: Sand Slabs ---

# The stack is tall enough that you'll have to be careful about choosing which
# bricks to disintegrate; if you disintegrate the wrong brick, large portions of
# the stack could topple, which sounds pretty dangerous.

# The Elves responsible for water filtering operations took a snapshot of the
# bricks while they were still falling (your puzzle input) which should let you
# work out which bricks are safe to disintegrate.

# Each line of text in the snapshot represents the position of a single brick at
# the time the snapshot was taken. The position is given as two x,y,z
# coordinates - one for each end of the brick - separated by a tilde (~). Each
# brick is made up of a single straight line of cubes, and the Elves were even
# careful to choose a time for the snapshot that had all of the free-falling
# bricks at integer positions above the ground, so the whole snapshot is aligned
# to a three-dimensional cube grid.

# The ground is at z=0 and is perfectly flat; the lowest z value a brick can
# have is therefore 1. So, 5,5,1~5,6,1 and 0,2,1~0,2,5 are both resting on the
# ground, but 3,3,2~3,3,3 was above the ground at the time of the snapshot.

# Because the snapshot was taken while the bricks were still falling, some
# bricks will still be in the air; you'll need to start by figuring out where
# they will end up. Bricks are magically stabilized, so they never rotate, even
# in weird situations like where a long horizontal brick is only supported on
# one end. Two bricks cannot occupy the same position, so a falling brick will
# come to rest upon the first other brick it encounters.

# Now that all of the bricks have settled, it becomes easier to tell which
# bricks are supporting which other bricks:

# Your first task is to figure out which bricks are safe to disintegrate. A
# brick can be safely disintegrated if, after removing it, no other bricks would
# fall further directly downward. Don't actually disintegrate any bricks - just
# determine what would happen if, for each brick, only that brick were
# disintegrated. Bricks can be disintegrated even if they're completely
# surrounded by other bricks; you can squeeze between bricks if you need to.

# Figure how the blocks will settle based on the snapshot. Once they've settled,
# consider disintegrating a single brick; how many bricks could be safely chosen
# as the one to get disintegrated?



EXAMPLE1 = <<~'EXAMPLE'
          1,0,1~1,2,1
          0,0,2~2,0,2
          0,2,3~2,2,3
          0,0,4~0,2,4
          2,0,5~2,2,5
          0,1,6~2,1,6
          1,1,8~1,1,9
          EXAMPLE


class TestMain < Minitest::Test
  def test_run
    assert_equal(5, Main.run!(EXAMPLE1))
  end
end

class Main
  class << self
    def run!(input)
    end
  end
end
