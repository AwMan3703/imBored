import Feed from "@components/Feed"

const Home = () => {
  return (
    <section className="w-full flex-center flex-col">
        <h1 className="head_text text-center">This is just a
        <br className="md:hidden"/>
        <span className="orange_gradient text-center"> proof of concept</span>
        </h1>
        <p className="desc text-center">
          Rumor is a mockup for a react-based social media app.
          <br />
          Explore the various pages and functionalities, including a functional posts and account system.
        </p>
        <hr className="w-3/4 my-5"/>

        <Feed/>
    </section>
  )
}

export default Home