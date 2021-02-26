# Gameplay (EN / [RU](gameplay_ru.md))

[<< Back](README.md)

![](screenshot.png)

## A Description of Game Fields

The game has two fields: **the primary one** and **the movable part**.

The primary field is represented by a set of **blue** cells. A player can not control the state of this field directly.

The movable part is represented by a set of **green** cells surrounded by a yellow frame. This field locates above the primary one and partially overlaps it. A player can control the position and orientation of this field. An initial position is **an upper left corner**.

At beginning of the game, both fields are filled with **a certain number** of cells **located randomly**.

## Interacting with the Movable Part of ​​the Field

A player can **move** this field **to the left**, **to the right**, **upward**, and **downward**. Wherein the movable part can not go beyond the limits of the primary field.

A player can **rotate** this field. Rotation is carried out only **clockwise** and always **divisible by 90 degrees**.

The boundaries of this field are set by a yellow frame and do not depend on the presence of green cells. Thus their absence in any row or column does not reduce the size of the movable part. A situation is possible when this field rests against the edge of the primary one although the side on which it rests is devoid of any cells. This makes it possible to rotate the field at any position.

A player can **merge** this field **with the primary one**. This is possible only if there are no blue ones under green cells. Otherwise, no merge is available and conflicting cells are shown in **red**.

When fields are merged (see also below) the current movable part is deleted, and a new one is created in the upper left corner **with the same number** of randomly located cells.

## Functioning of the Primary Field

This field remains static throughout the game except when it merges with the movable part.

When the fields merge the cells of the movable part are added to the primary field and turn blue.

After that, the rules of the game ["Life"](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) are applied to this field. Wherein the field is considered open and bounded by empty unchangeable cells. The conversion is only done for one generation.

## Game Goals and Statistics

The global goal of the game is to completely clear the primary field of blue cells. However, in practice, it is extremely difficult to achieve. Therefore the **maximum reduction** of the number of these cells is considered as an alternative.

It is important to understand that the moment at which this quantity is estimated is the moment **after merging** of the fields **and application of the rules** of the game ["Life"](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) to the primary field.

The game keeps some statistics memorizing the minimum value of the number of blue cells for all completed game sessions.
