

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