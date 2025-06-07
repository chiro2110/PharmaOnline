using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;



using System.Threading;
using System.IO;
using Firebase.Auth;
using Firebase.Storage;

namespace CapaNegocio
{
    public class CN_FireBase
    {


        public async Task<string> SubirStorage(Stream archivo, string nombre)
        {
            string UrlImagen = string.Empty;

            string email = "Ingrese aqui";
            string clave = "Ingrese aqui";
            string ruta = "Ingrese aqui";
            string api_key = "Ingrese aqui";

            try
            {

                var auth = new FirebaseAuthProvider(new FirebaseConfig(api_key));
                var a = await auth.SignInWithEmailAndPasswordAsync(email, clave);

                var cancellation = new CancellationTokenSource();

                var task = new FirebaseStorage(
                    ruta,
                    new FirebaseStorageOptions
                    {
                        AuthTokenAsyncFactory = () => Task.FromResult(a.FirebaseToken),
                        ThrowOnCancel = true
                    })
                    .Child("IMAGENES_PRODUCTO")
                    .Child(nombre)
                    .PutAsync(archivo, cancellation.Token);


                UrlImagen = await task;
            }
            catch
            {
                UrlImagen = "";
            }


            return UrlImagen;


        }
    }
}

