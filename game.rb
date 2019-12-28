

# ok, so I'm gonna write an algorythm to solve sudokus.  I wonder what the best way to represent that data is
# probably you're standard grid situation, 9*9


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


# okay, so initial thought is: "I have no idea how to do this"
# this algorithm has been written many times, so I can certainly look it up, but 
# before I do that I need to give it a decent try

# I'll try and break it down according to moves I would do as a human.

# or, I could just build another map of potentials for each position...
# I kinda think that's what I'll need to do
def generate_possibilities grid
    # some spooky stuff to duplicate the 2 dimensional array
    possibilities = Marshal.load(Marshal.dump(grid))
    possibilities.each_with_index do |row, row_number|
        # generate_possibility char
        ruled_out_by_row = row.select{|x| x.is_a?(Numeric) && x != 0 }
        row_posibilities = [1,2,3,4,5,6,7,8,9] - ruled_out_by_row
        row.each_with_index do |char, char_number|
            # first of all I'll just generate posibilities based on row rules
            if char == 0
                row[char_number] = row_posibilities
            end
        end
    end

    possibilities.each do |row|
        p row
    end
end

generate_possibilities(initial)