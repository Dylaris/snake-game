#include <iostream>
#include <raylib.h>

static constexpr int cell_size = 32; // Equal to the width and height of 'food.png'
static constexpr int cell_count = 20;
static constexpr Color bg_color = {173, 204, 96, 255};
static constexpr Color snake_color = {43, 51, 24, 255};

struct Food {
    Vector2 position = {5, 6};
    Texture2D texture;

    Food()
    {
        Image image = LoadImage("./food.png");
        texture = LoadTextureFromImage(image);
        UnloadImage(image);
        position = generate_random_pos();
    }

    void draw()
    {
        DrawTexture(texture, cell_size*position.x, cell_size*position.y, WHITE);
    }

    Vector2 generate_random_pos()
    {
        float x = GetRandomValue(0, cell_count-1);
        float y = GetRandomValue(0, cell_count-1);
        return Vector2{x, y};
    }
};

int main(void)
{
    InitWindow(cell_size*cell_count, cell_size*cell_count, "My Snake Game");
    SetTargetFPS(60);

    Food food = Food();

    while (!WindowShouldClose()) {
        BeginDrawing();

        // Drawing
        ClearBackground(bg_color);
        food.draw();

        EndDrawing();
    }

    CloseWindow();
    return 0;
}
