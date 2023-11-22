<script>
    import { spring } from 'svelte/motion';
    import { geoOrthographic, geoCentroid } from 'd3-geo';
    import { feature } from 'topojson-client';
    import { Chart, Svg, GeoPath, Graticule, Tooltip, Zoom } from 'layerchart'
    import data from './countries-110m.json'
    import { Button, scrollIntoView, cls, sortFunc, ButtonGroup } from 'svelte-ux';

    const countries = feature(data, data.objects.countries);
  
    const springOptions = { stiffness: 0.04 };
    const yaw = spring(0, springOptions);
    const pitch = spring(0, springOptions);
    const roll = spring(0, springOptions);
  
    let selectedFeature;
    $: if (selectedFeature) {
      const centroid = geoCentroid(selectedFeature);
      $yaw = -centroid[0];
      $pitch = -centroid[1];
    }
  
  </script>
  

    <div class="h-[600px] grid grid-cols-[224px,1fr] relative">
      <div class="absolute top-0 right-0 z-10 flex items-center gap-3">
        {#if selectedFeature}
          <span class="text-sm px-2 py-1 font-semibold text-blue-500 bg-blue-50 rounded-full">
            {selectedFeature?.properties.name ?? ''}
          </span>
        {/if}
      
      </div>
  
      <div class="overflow-auto scrollbar-none">
        {#each countries.features.sort(sortFunc('properties.name')) as country}
          {@const isSelected = selectedFeature === country}
          <div use:scrollIntoView={{ condition: isSelected }}>
            <Button
              variant={isSelected ? 'fill-light' : 'default'}
              color={isSelected ? 'red' : 'default'}
              fullWidth
              on:click={() => (selectedFeature = country)}
            >
              {country.properties.name}
            </Button>
          </div>
        {/each}
      </div>
      <Chart
        geo={{
          projection: geoOrthographic,
          fitGeojson: countries,
          rotate: {
            yaw: $yaw,
            pitch: $pitch,
            roll: $roll,
          },
        }}
        tooltip={{ mode: 'manual' }}
        let:tooltip
      >
        <Svg>
          <GeoPath geojson={{ type: 'Sphere' }} class="fill-blue-300" />
          <Graticule class="stroke-black/20" />
          {#each countries.features as country}
            <GeoPath
              geojson={country}
              class={cls(
                'fill-white cursor-pointer',
                selectedFeature === country ? 'fill-red-400' : 'hover:fill-gray-200'
              )}
              on:click={(e) => (selectedFeature = country)}
              {tooltip}
            />
          {/each}
        </Svg>
  
        <Tooltip>
          <div slot="header" let:data>{data.properties.name}</div>
        </Tooltip>
      </Chart>
    </div>
  