import Post from "@models/post";
import { connectToDB } from "@utils/database";

export const POST = async (request) => {
    const { userId, content, tag } = await request.json();

    try {
        await connectToDB();
        const newPost = new Post({ creator: userId, content, tag });

        await newPost.save();
        return new Response(JSON.stringify(newPost), { status: 201 })
    } catch (error) {
        console.log(error);
        return new Response("Failed to create a new post", { status: 500 });
    }
}