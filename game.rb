class Game

    @@point_to_section_map = [
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

    def initialize(grid)
        # grid[*][column_number]
        @ruled_out_by_column = {
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
        # grid[row_number][*]
        @ruled_out_by_row = {
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
        @ruled_out_by_section = {
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
        @grid = grid
        generate_possibilities(grid)
    end

    def generate_possibilities grid
        generate_row_possibilities(grid)
        generate_column_possibilities(grid)
        generate_section_possibilities(grid)
    end

    def solve
        # while !solved?
            [0,1,2,3,4,5,6,7,8].each do |num|
                solve_by_strict_elimination
                solve_by_row_elimination(num)
                solve_by_column_elimination(num)
            end
        # solve_by_strict_elimination
        # end
    end

    def solved?
        @grid.each do |row|
            if row.include? 0
                return false
            end
        end
        return true
    end

    def ruled_out_by_column
        @ruled_out_by_column
    end

    def ruled_out_by_row
        @ruled_out_by_row
    end

    def ruled_out_by_section
        @ruled_out_by_section
    end

    def grid
        @grid
    end

    def pretty_grid
        @grid.map { |x| x.join(' ') }
    end

    private

    def generate_row_possibilities grid
        possibilities = Marshal.load(Marshal.dump(grid))
        possibilities.each_with_index do |row, row_number|
            ruled_out_by_current_row = row.select{|x| x.is_a?(Numeric) && x != 0 }
            @ruled_out_by_row[row_number] = ruled_out_by_current_row
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
            @ruled_out_by_column[char_index] = ruled_out
            char_index += 1
        end
    end


    def generate_section_possibilities grid
        (0..8).each do |x|
            (0..8).each do |y|
                section_number = @@point_to_section_map[x][y]
                if grid[x][y] != 0
                    @ruled_out_by_section[section_number].push(grid[x][y]) 
                end
            end
        end
    end

    def generate_possibilities_for_a_point(x, y)
        possibilities = [1,2,3,4,5,6,7,8,9] - @ruled_out_by_row[x]
        # p @ruled_out_by_row[x], 125
        possibilities = possibilities - @ruled_out_by_column[y]
        section_number = @@point_to_section_map[x][y]
        # p @ruled_out_by_column[y]
        possibilities = possibilities - @ruled_out_by_section[section_number]
        # p @ruled_out_by_section[section_number], 130
        return possibilities
    end

    def solve_by_strict_elimination
        # p "solve by strict"
        (0..8).each do |y|
            (0..8).each do |x|
                if grid[x][y] == 0 
                    possibilities = generate_possibilities_for_a_point(x, y)
                    if possibilities.length == 1
                        grid[x][y] = possibilities[0]
                        @ruled_out_by_row[x].push(possibilities[0])
                        @ruled_out_by_column[y].push(possibilities[0])
                        section_number = @@point_to_section_map[x][y]
                        @ruled_out_by_section[section_number].push(possibilities[0])
                        return solve_by_strict_elimination
                    end
                end
            end
        end
        return false
    end

    def solve_by_row_elimination(x)
        # p "solve by row"
        remaining_numbers = [1,2,3,4,5,6,7,8,9] - @ruled_out_by_row[x]
        if remaining_numbers.empty?
            return true
        end
        remaining_numbers.each do |remaining_number|
            # [1, 5]
            possible_y = []
            [0,1,2,3,4,5,6,7,8].each do |y|
                # p "iterating", remaining_number, y, possible_y
                break if possible_y.length > 1
                if @grid[x][y] == 0
                    possibilities = generate_possibilities_for_a_point(x, y)
                    possible_y.push(y) if possibilities.include? remaining_number
                end
            end
            if possible_y.length == 1
                p "Got one ----------------------- ", x, possible_y[0], remaining_number
                @grid[x][possible_y[0]] = remaining_number
                
                @ruled_out_by_row[x].push(remaining_number)
                @ruled_out_by_column[possible_y[0]].push(remaining_number)
                section_number = @@point_to_section_map[x][possible_y[0]]
                @ruled_out_by_section[section_number].push(remaining_number)
                return solve_by_row_elimination(x)
            end
        end
        false
    end

    def solve_by_column_elimination(y)
        # p "solve by column"
        remaining_numbers = [1,2,3,4,5,6,7,8,9] - @ruled_out_by_row[y]
        if remaining_numbers.empty?
            return true
        end

        remaining_numbers.each do |remaining_number|
            possible_x = []
            [0,1,2,3,4,5,6,7,8].each do |x|
                break if possible_x.length > 1 
                if @grid[x][y] == 0
                    possibilities = generate_possibilities_for_a_point(x, y)
                    possible_x.push(x) if possibilities.include? remaining_number
               end
            end
            if possible_x.length == 1
                p "Got one ----------------------- ", possible_x[0], y, remaining_number
                @grid[possible_x[0]][y] = remaining_number
                @ruled_out_by_row[possible_x[0]].push(remaining_number)
                @ruled_out_by_column[y].push(remaining_number)
                section_number = @@point_to_section_map[possible_x[0]][y]
                @ruled_out_by_section[section_number].push(remaining_number)
                return solve_by_column_elimination(y)
            end
        end
        false
    end

end


first_game = Game.new([
    [0,2,0,0,0,0,0,0,3],
    [5,0,0,0,0,8,4,0,0],
    [0,0,0,2,5,0,0,1,6],
    [0,7,0,0,2,9,0,0,0],
    [0,4,0,0,3,0,0,6,0],
    [0,0,0,6,8,0,0,2,0],
    [2,8,0,0,4,7,0,0,0],
    [0,0,3,8,0,0,0,0,1],
    [9,0,0,0,0,0,0,5,0],
])


# p "row", first_game.ruled_out_by_row
# p "column", first_game.ruled_out_by_column
# p "section", first_game.ruled_out_by_section
# p first_game.grid
# first_game.solve_by_strict_elimination
# first_game.solved?
# p first_game.grid
# p "row", first_game.ruled_out_by_row
# p "column", first_game.ruled_out_by_column
# p "section", first_game.ruled_out_by_section

puts first_game.pretty_grid
p first_game.grid[6][5]
p first_game.solve
p first_game.grid[6][5]
puts first_game.pretty_grid
#  maybe i can eventually abstract out a function which can take either row, column, or section























 # def solve(grid)
    #     (0..8).each do |y|
    #         (0..8).each do |x|
    #             if grid[x][y] == 0 
    #                 possibilities = generate_possibilities_for_a_point(x, y)
    #                 if possibilities.length == 1
    #                     grid[x][y] = possibilities[0]
    #                     # p [x, y], possibilities[0]
    #                     @ruled_out_by_row[x].push(possibilities[0])
    #                     @ruled_out_by_column[y].push(possibilities[0])
    #                     section_number = @@point_to_section_map[x][y]
    #                     @ruled_out_by_section[section_number].push(possibilities[0])
    #                     return solve(grid)
    #                 end
    #             end
    #         end
    #     end

    #     return true
    # end