"use client"

import Link from "next/link"
import Image from "next/image"
import { useState, useEffect } from "react"
import { signIn, signOut, useSession, getProviders } from 'next-auth/react'

const Nav = () => {
  const { data: session } = useSession();

  const [providers, setProviders] = useState(null);
  const [toggleDropdown, setToggleDropdown] = useState(false)

  useEffect(() => {
    const setUpProviders = async () => {
      const response = await getProviders();

      setProviders(response);
    }

    setUpProviders();
  }, []);

  return (
    <nav className="flex-between w-full sm:mb-7 md:mb-12 pt-3">
      <Link href="/" className="flex gap-2 flex-center">
        <Image
        width={30}
        height={30}
        className="object-contain"
        alt="Rumor logo"
        src="/assets/images/logo.svg"/>
        <p className="logo_text">Rumor</p>
      </Link>

      {/*Desktop navigation*/}
      <div className="sm:flex hidden">
        {session?.user ? (
          <div className="flex gap-3 md:gap-5">
            <Link href="/create-post" className="black_btn">Create new Post</Link>
            <button type="button" onClick={signOut} className="outline_btn">Sign Out</button>
            <Link href="/profile">
              <Image
              height={37}
              width={37}
              className="rounded-full"
              alt="profile"
              src={session?.user.image}/>
            </Link>
          </div>
        ) : (
          <>
            {providers &&
            Object.values(providers).map((provider) => (
              <button
              type="button"
              key={provider.name}
              onClick={() => signIn(provider.id)}
              className="black_btn">
                Sign In
              </button>
            ))}
          </>
        )}
      </div>

      {/*Moblie navigaation*/}
      <div className="sm:hidden flex relative">
      {session?.user ? (
        <div className="flex">
          <Image
          height={37}
          width={37}
          className="rounded-full"
          alt="profile"
          onClick={()=> setToggleDropdown((prev) => !prev) }
          src={session?.user.image}/>

          {toggleDropdown &&
          <div className="dropdown">
            <Link
            href="/profile"
            className="dropdown_link"
            onClick={() => setToggleDropdown(false)}
            >
              My Profile
            </Link>
            <Link
            href="/create-post"
            className="dropdown_link"
            onClick={() => setToggleDropdown(false)}
            >
              New Post
            </Link>
            <button
            type="button"
            onClick={() => {
              setToggleDropdown(false);
              signOut()
            }}
            className="mt-5 w-full black_btn"
            >
              Sign Out
            </button>
          </div>
          }
        </div>
      ) : (
        <>
          {providers &&
          Object.values(providers).map((provider) => (
            <button
            type="button"
            key={provider.name}
            onClick={() => signIn(provider.id)}
            className="black_btn">
              Sign In
            </button>
          ))}
        </>
      )}
    </div>

    </nav>
  )
}

export default Nav