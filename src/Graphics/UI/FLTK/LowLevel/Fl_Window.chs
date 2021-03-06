{-# LANGUAGE CPP #-}
module Graphics.UI.FLTK.LowLevel.Fl_Window where
#include "Fl_C.h"
#include "Fl_WindowC.h"
import Foreign
import Foreign.C
import Graphics.UI.FLTK.LowLevel.Fl_Types
import Graphics.UI.FLTK.LowLevel.Fl_Enumerations

{# fun unsafe Fl_Window_handle as windowHandle'
       {id `Ptr ()', cFromEnum `Event'} -> `Bool' cToBool #}
windowHandle :: WindowPtr -> Event -> IO Bool
windowHandle windowPtr event =
    withForeignPtr windowPtr
           (\p -> (windowHandle' (castPtr p) event))

{# fun unsafe Fl_Window_New_WithLabel as
              windowNewWithLabel' {`Int', `Int', `String'} -> `Ptr ()' id #}
windowNewWithLabel :: Int -> Int -> String -> IO WindowPtr
windowNewWithLabel w h title = do
  rawPtr <- windowNewWithLabel' w h title
  newForeignPtr_ (castPtr rawPtr)
{# fun unsafe Fl_Window_show as windowShow' {id `Ptr ()'} -> `()' #}
windowShow :: WindowPtr -> IO ()
windowShow windowPtr = withForeignPtr windowPtr (\p -> windowShow' (castPtr p))

{# fun unsafe Fl_Window_set_callback_with_user_data as
              windowSetCallbackWithUserData'
              {id `Ptr ()' , id `FunPtr CallbackPrim', id `Ptr ()'} -> `()' #}
windowSetCallbackWithUserData :: WindowPtr ->
                                 CallbackPrim ->
                                 UserDataPtr ->
                                 IO ()
windowSetCallbackWithUserData windowPtr callback userDataPtr =
    withForeignPtr windowPtr
       (\w -> withForeignPtr userDataPtr
            (\u -> do
               callbackPtr <- mkCallbackPtr callback
               windowSetCallbackWithUserData' (castPtr w)
                                              callbackPtr
                                              (castPtr u)))

{# fun unsafe Fl_Window_set_callback as
              windowSetCallback' {id `Ptr ()' , id `FunPtr CallbackPrim'}
              -> `()' #}

windowSetCallback :: WindowPtr -> CallbackPrim -> IO ()
windowSetCallback windowPtr callback =
    withForeignPtr windowPtr (\w -> do
                                  callbackPtr <- mkCallbackPtr callback
                                  windowSetCallback' (castPtr w) callbackPtr)

foreign import ccall "wrapper"
        mkCallbackPtr :: CallbackPrim -> IO (FunPtr CallbackPrim)
