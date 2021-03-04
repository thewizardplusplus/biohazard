# Gameplay (EN / [RU](gameplay_ru.md))

[<< Back](README.md)

![](screenshot.png)

## Description of Game Fields

The game has two fields: **the primary one** and **the movable part**.

The primary field is represented by a set of **blue** cells. The player cannot control the state of this field directly.

The movable part is represented by a set of **green** cells surrounded by the yellow frame. This field is located above the primary one and partially overlaps it. The player can control the position and orientation of this field. The initial position is **the upper left corner**.

At the beginning of the game, both fields are filled with **a certain amount** of cells **located randomly**.

## Interacting with the Movable Part of the Field

The player can **move** this field **to the left**, **to the right**, **upward**, and **downward**. With that, the movable part cannot go beyond the limits of the primary field.

The player can **rotate** this field. The rotation is carried out only **clockwise** and always **divisible by 90 degrees**.

The boundaries of this field are set by the yellow frame and are not depend on the presence of green cells. Thus, their absence in any row or column does not reduce the size of the movable part. A situation is possible when this field rests against the edge of the primary one, although the side on which it rests is devoid of any cells. It makes it possible to rotate the field at any position.

The player can **merge** this field **with the primary one**. It is possible only if there are no blue cells under green ones. Otherwise, no merge is available and conflicting cells are shown in **red**.

When the fields are merged (see also below), the current movable part is deleted, and a new one is created in the upper left corner **with the same amount** of randomly located cells.

## Functioning of the Primary Field

This field remains static throughout the game except when it is merged with the movable part.

When the fields are merged, the cells of the movable part are added to the primary field and turn blue.

After that, the rules of the ["Life"](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) game are applied to this field. With that, the field is considered open (i.e. not toroidal) and surrounded by empty unchangeable cells. The transformation is done for one generation only.

## Game Goals and Statistics

The global goal of the game is to clear the primary field of blue cells completely. However, in practice, it is extremely difficult to achieve. Therefore, the **maximum reduction** of the amount of these cells is considered as an alternative.

It is important to understand that the moment at which this quantity is estimated is the moment **after merging** of the fields **and application of the rules** of the ["Life"](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) game to the primary field.

The game keeps some statistics by memorizing the minimum value of the amount of blue cells for all completed game sessions.
