

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

# the grid needs to be accessed like this grid[y][x]

$point_to_section_map = [ # grid[0][5] => 1
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

$ruled_out_by_column = { # grid[*][column_number]
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

$ruled_out_by_row = { # grid[row_number][*]
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



def generate_row_possibilities grid
    # some spooky stuff to duplicate the 2 dimensional array
    possibilities = Marshal.load(Marshal.dump(grid))
    possibilities.each_with_index do |row, row_number|
        # generate_possibility char
        ruled_out_by_current_row = row.select{|x| x.is_a?(Numeric) && x != 0 }
        $ruled_out_by_row[row_number] = ruled_out_by_current_row
    end
end



def generate_column_possibilities grid
    char_index = 0
    while char_index < 9
        column_possibilities = [1,2,3,4,5,6,7,8,9]
        ruled_out = []
        row_index = 0
        while row_index < 9 
            ruled_out.push(grid[row_index][char_index]) if grid[row_index][char_index] != 0
            row_index += 1
        end
        $ruled_out_by_column[char_index] = ruled_out
        char_index += 1
    end
end


def generate_section_possibilities grid
    (0..8).each do |x|
        (0..8).each do |y|
            section_number = $point_to_section_map[x][y]
            if grid[x][y] != 0
                $ruled_out_by_section[section_number].push(grid[x][y]) 
            end
        end
    end
end



def generate_possibilities_for_a_point(x, y)
    possibilities = [1,2,3,4,5,6,7,8,9] - $ruled_out_by_row[x]
    # p $ruled_out_by_row[x], 125
    possibilities = possibilities - $ruled_out_by_column[y]
    section_number = $point_to_section_map[x][y]
    # p $ruled_out_by_column[y]
    possibilities = possibilities - $ruled_out_by_section[section_number]
    # p $ruled_out_by_section[section_number], 130
    return possibilities
end


def generate_possibilities grid
    generate_row_possibilities(grid)
    generate_column_possibilities(grid)
    generate_section_possibilities(grid)
    
    p $ruled_out_by_row
    p $ruled_out_by_column
    p $ruled_out_by_section

    (0..8).each do |y|
        (0..8).each do |x|
            if grid[x][y] == 0 
                possibilities = generate_possibilities_for_a_point(x, y)
                if possibilities.length == 1
                    section_number = $point_to_section_map[x][y]
                    return [x,y, possibilities]
                end
            end
        end
    end
end


p generate_possibilities(initial)

# p generate_possibilities_for_a_point(0, 5)
