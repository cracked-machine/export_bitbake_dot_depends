import networkx as nx
from networkx import nx_pydot
import matplotlib.pyplot as plt
from os import walk
import pathlib

if __name__ == "__main__":
    _in_dir = pathlib.Path("../export/").absolute()

    print(_in_dir)
    for (dirpath, dirnames, filenames) in walk(_in_dir):
        for filename in filenames:
            if filename.endswith(".dot"):

                _dotfile = filename
                _input_path = pathlib.Path(f"{dirpath}/{_dotfile}")
                _output_path = pathlib.Path(f"./png/")
                print(_dotfile)

                g = nx_pydot.read_dot(_input_path)
                g_pos = nx.spring_layout(g, k=1)

                plt.figure(3, figsize=(64, 64))
                nx.draw(g, g_pos, node_size=10, width=0.5, with_labels=True)
                # plt.show(block=False)

                if not _output_path.exists():
                    _output_path.mkdir()
                _full_output_path = _output_path.joinpath(
                    _dotfile.replace(".dot", ".png")
                )
                plt.savefig(_full_output_path, format="PNG")
