package controller

import (
	"io/fs"
	"net/http"

	"github.com/gin-gonic/gin"
)

type pwaAsset struct {
	path        string
	contentType string
	// cacheable assets are safe to keep; the shell and the service worker are
	// not, because a stale copy pins the browser to an old panel build.
	cacheable bool
}

var pwaAssets = map[string]pwaAsset{
	"manifest.webmanifest":   {path: "dist/manifest.webmanifest", contentType: "application/manifest+json; charset=utf-8"},
	"pwa-register.js":        {path: "dist/pwa-register.js", contentType: "application/javascript; charset=utf-8"},
	"service-worker.js":      {path: "dist/service-worker.js", contentType: "application/javascript; charset=utf-8"},
	"favicon.ico":            {path: "dist/favicon.ico", contentType: "image/x-icon", cacheable: true},
	"apple-touch-icon.png":   {path: "dist/apple-touch-icon.png", contentType: "image/png", cacheable: true},
	"icons/easyxray-16.png":  {path: "dist/icons/easyxray-16.png", contentType: "image/png"},
	"icons/easyxray-24.png":  {path: "dist/icons/easyxray-24.png", contentType: "image/png"},
	"icons/easyxray-32.png":  {path: "dist/icons/easyxray-32.png", contentType: "image/png"},
	"icons/easyxray-64.png":  {path: "dist/icons/easyxray-64.png", contentType: "image/png"},
	"icons/easyxray-192.png": {path: "dist/icons/easyxray-192.png", contentType: "image/png"},
	"icons/easyxray-512.png": {path: "dist/icons/easyxray-512.png", contentType: "image/png"},
}

func servePWAAsset(c *gin.Context, assetName string) {
	asset, ok := pwaAssets[assetName]
	if !ok {
		c.AbortWithStatus(http.StatusNotFound)
		return
	}

	body, err := fs.ReadFile(distFS, asset.path)
	if err != nil {
		c.AbortWithStatus(http.StatusNotFound)
		return
	}

	if asset.cacheable {
		c.Header("Cache-Control", "public, max-age=86400")
	} else {
		c.Header("Cache-Control", "no-cache, no-store, must-revalidate")
		c.Header("Pragma", "no-cache")
		c.Header("Expires", "0")
	}
	c.Data(http.StatusOK, asset.contentType, body)
}

func ServePWAManifest(c *gin.Context) {
	servePWAAsset(c, "manifest.webmanifest")
}

func ServePWARegister(c *gin.Context) {
	servePWAAsset(c, "pwa-register.js")
}

func ServePWAServiceWorker(c *gin.Context) {
	servePWAAsset(c, "service-worker.js")
}

func ServePWAIcon(c *gin.Context) {
	servePWAAsset(c, "icons/"+c.Param("name"))
}

func ServePWAFavicon(c *gin.Context) {
	servePWAAsset(c, "favicon.ico")
}

func ServePWAAppleTouchIcon(c *gin.Context) {
	servePWAAsset(c, "apple-touch-icon.png")
}
