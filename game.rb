

# ok, so I'm gonna write an algorythm to solve sudokus.  
# I wonder what the best way to represent that data is
# probably you're standard grid situation, 9*9

# another option is to create separate classes for both a character and a grid.
# that's the more complex thorough solution.


# rules that need to be followed, each column must contain numbers 1-9, 
# each row must also contain numbers 1-9,
# each smaller grid of 9 must also contain exactly numbers 1-9,
# no zeros, so they can be a placeholder

initial = [
    [0,2,0,0,0,0,0,0,3],
    [5,0,0,0,0,8,4,0,0],
    [0,0,0,2,5,0,0,1,6],
    [0,7,0,0,2,9,0,0,0],
    [0,4,0,0,3,0,0,6,0],
    [0,0,0,6,8,0,0,2,0],
    [2,8,0,0,4,7,0,0,0],
    [0,0,3,8,0,0,0,0,1],
    [9,0,0,0,0,0,0,5,0],
]

$ruled_out_by_column = {
        0 => [],
        1 => [],
        2 => [],
        3 => [],
        4 => [],
        5 => [],
        6 => [],
        7 => [],
        8 => []
    }
# the fact that I'm using a global var means that I should probably be using classes,
# but I can refactor later
$ruled_out_by_row = {
        0 => [],
        1 => [],
        2 => [],
        3 => [],
        4 => [],
        5 => [],
        6 => [],
        7 => [],
        8 => []
    }

# or, I could just build another map of potentials for each position...
# I kinda think that's what I'll need to do
def generate_possibilities grid
    # some spooky stuff to duplicate the 2 dimensional array
    possibilities = Marshal.load(Marshal.dump(grid))
    possibilities.each_with_index do |row, row_number|
        # generate_possibility char
        ruled_out_by_current_row = row.select{|x| x.is_a?(Numeric) && x != 0 }
        row_posibilities = [1,2,3,4,5,6,7,8,9] - ruled_out_by_current_row
        $ruled_out_by_row[row_number] = row_posibilities
        row.each_with_index do |char, char_number|

        end
    end

    # possibilities.each do |row|
    #     p row
    # end

    p $ruled_out_by_row
    p $ruled_out_by_column
end



def generate_column_possibilities grid
    char_index = 0
    while char_index < 9
        column_possibilities = [1,2,3,4,5,6,7,8,9]
        ruled_out = []
        row_index = 0
        while row_index < 9 
            ruled_out.push(grid[row_index][char_index])
            row_index += 1
        end
        $ruled_out_by_column[char_index] = column_possibilities - ruled_out
        char_index += 1
    end
end



generate_column_possibilities(initial) 
generate_possibilities(initial)




$ruled_out_by_section = {
    0 => [],
    1 => [],
    2 => [],
    3 => [],
    4 => [],
    5 => [],
    6 => [],
    7 => [],
    8 => []
}

# $section_map = {
#     []
# }

    # section 0 -> coordinates 0-2, 0-2
    # section 1 -> coordinates 0-2, 3-5
    # section 2 -> coordinates 0-2, 6-8

    # section 3 -> coordinates 3-5, 0-2
    # section 4 -> coordinates 3-5, 3-5
    # section 5 -> coordinates 3-5, 6-8

    # section 6 -> coordinates 6-8, 0-2
    # section 7 -> coordinates 6-8, 3-5
    # section 8 -> coordinates 6-8, 6-8

    # What would a data structure look like that I could plug any point into 
    # and return its section number?

    # probably another grid? That's gotta be the easiest thing
    # keeping the x's and the y's clear could be a bit tricky

$point_to_section_map = [
    [0,0,0,1,1,1,2,2,2],
    [0,0,0,1,1,1,2,2,2],
    [0,0,0,1,1,1,2,2,2],
    [3,3,3,4,4,4,5,5,5],
    [3,3,3,4,4,4,5,5,5],
    [3,3,3,4,4,4,5,5,5],
    [6,6,6,7,7,7,8,8,8],
    [6,6,6,7,7,7,8,8,8],
    [6,6,6,7,7,7,8,8,8],
]
# hell yeah, that's easy

def generate_section_possibilities grid
    (0..8).each do |x|
        (0..8).each do |y|
            section_number = $point_to_section_map[x][y]
            p grid[x][y]
            if grid[x][y] != 0
                $ruled_out_by_section[section_number].push(grid[x][y]) 
            end
        end
    end
end

p generate_section_possibilities(initial)
p $ruled_out_by_section